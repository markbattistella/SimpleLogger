//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

#Preview {
    LogListScreen.ExportSheet()
        .environment(LoggerManager())
}

extension LogListScreen {

    /// A modal sheet that allows the user to export log data in various formats, optionally
    /// compressed, either to a file or the clipboard.
    ///
    /// The sheet supports CSV, JSON, JSON Lines, and plain log formats, with optional Gzip
    /// compression for file exports.
    internal struct ExportSheet: View {

        /// The shared logger manager used to perform exports and surface errors.
        @Environment(LoggerManager.self)
        private var logManager

        /// Dismiss action for closing the sheet.
        @Environment(\.dismiss)
        private var dismiss

        /// The selected base export format (log, JSON, JSONL, or CSV).
        @State
        private var baseFormat: Export.Kind = .log

        /// The delimiter used when exporting CSV data.
        @State
        private var csvDelimiter: Export.Delimiter = .comma

        /// Indicates whether the exported file should be gzip-compressed.
        @State
        private var useGzip: Bool = false

        /// The temporary URL of the prepared export file.
        @State
        private var temporaryExport: URL?

        /// Controls presentation of the system file mover.
        @State
        private var showFileExport: Bool = false

        /// A logger instance scoped to file system–related operations.
        private let logger = SimpleLogger(category: .fileSystem)

        /// Resolves the final export format by combining the selected base format with delimiter
        /// and compression options.
        private var resolvedExportFormat: Export.Format {
            let base: Export.Format = {
                switch baseFormat {
                    case .log: return .log
                    case .json: return .json
                    case .jsonLines: return .jsonLines
                    case .csv: return .csv(csvDelimiter)
                }
            }()

            return useGzip ? .gzip(base) : base
        }

        var body: some View {
            NavigationStack {
                Form {
                    Section {
                        Picker("Output format", selection: $baseFormat) {
                            ForEach(Export.Kind.allCases) { format in
                                Text(format.description)
                                    .tag(format)
                            }
                        }

                        if baseFormat == .csv {
                            Picker("CSV delimiter", selection: $csvDelimiter) {
                                ForEach(Export.Delimiter.allCases, id: \.self) { delimiter in
                                    Text(delimiter.label).tag(delimiter)
                                }
                            }
                        }

                        Toggle("Compression", isOn: $useGzip)
                    } header: {
                        Text("Options")
                    }

                    Section {
                        Button("Export to file", systemImage: "square.and.arrow.down") {
                            Task {
                                self.temporaryExport = await prepareExportFile()
                                self.showFileExport = true
                            }
                        }
                    }
                    .onChange(of: resolvedExportFormat) { temporaryExport = nil }

                    Section {
                        Button(
                            "Copy to clipboard",
                            systemImage: "doc.on.doc",
                            action: copyToClipboard
                        )
                    } footer: {
                        Text("Clipboard data will be in the output format you selected. Compression will not affect this.")
                    }
                }
                .navigationTitle("Export")

                #if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif

                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", systemImage: "checkmark") {
                            dismiss()
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .presentationDetents([.fraction(0.7), .large])
            .interactiveDismissDisabled()
            .fileMover(
                isPresented: $showFileExport,
                file: temporaryExport,
                onCompletion: handleFileMoverCompletion,
                onCancellation: handleFileMoverCancellation
            )
            .alert(item: Bindable(logManager).lastError) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK")) {
                        logManager.lastError = nil
                    }
                )
            }
        }
    }
}

// MARK: - Methods

extension LogListScreen.ExportSheet {

    /// Exports log data in the selected format and copies the result to the system clipboard as
    /// UTF-8 text.
    ///
    /// Compression settings are ignored for clipboard exports.
    private func copyToClipboard() {
        Task(priority: .userInitiated) {
            let result = await logManager.export(format: resolvedExportFormat)

            guard case let .success(data) = result,
                  let string = String(data: data, encoding: .utf8) else {
                return
            }

            await MainActor.run {
                #if os(macOS)
                let pb = NSPasteboard.general
                pb.clearContents()
                pb.setString(string, forType: .string)
                #else
                UIPasteboard.general.string = string
                #endif
            }
        }
    }

    /// Removes the temporary export file from disk if it exists.
    private func cleanupTempFile() {
        guard let url = temporaryExport else { return }
        try? FileManager.default.removeItem(at: url)
        temporaryExport = nil
    }

    /// Prepares an export file in the temporary directory using the selected export options.
    ///
    /// - Returns: A file URL pointing to the exported data, or `nil` if export fails.
    private func prepareExportFile() async -> URL? {
        let result = await logManager.export(format: resolvedExportFormat)

        guard case let .success(data) = result else {
            return nil
        }

        let filename = "Logs_\(Date.now.formatted(.iso8601))"
            .replacingOccurrences(of: ":", with: ".")

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(filename)
            .appendingPathExtension(resolvedExportFormat.filenameSuffix)

        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            return nil
        }
    }

    /// Handles the result of the file mover operation.
    ///
    /// - On success, the temporary file reference is cleared.
    /// - On failure, the error is surfaced and the temporary file is removed.
    private func handleFileMoverCompletion(_ result: Result<URL, any Error>) {
        switch result {
            case .success(let success):
                logger.info("Moved file to: \(success.absoluteString)")
                temporaryExport = nil

            case .failure(let error):
                logger.error("Failed to move file: \(error.localizedDescription)")
                logManager.lastError = .export(error)
                cleanupTempFile()
        }
    }

    /// Handles cancellation of the file mover by cleaning up temporary files.
    private func handleFileMoverCancellation() {
        cleanupTempFile()
    }
}
