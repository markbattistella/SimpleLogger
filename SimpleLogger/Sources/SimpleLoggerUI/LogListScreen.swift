//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
@_exported import SimpleLogger

#Preview {
    NavigationStack {
        LogListScreen()
    }
    .environment(LoggerManager())
}

/// A screen that displays a list of collected log entries.
///
/// `LogListScreen` is the primary interface for viewing application logs. It supports
/// pull-to-refresh, filtering, exporting, and contextual information about the most
/// recent fetch.
public struct LogListScreen: View {

    /// Manages log storage, filtering, exporting, and error state.
    @State
    private var logManager = LoggerManager()

    /// Controls presentation of the filter configuration sheet.
    @State
    private var showFilterSheet: Bool = false

    /// Controls presentation of the export options sheet.
    @State
    private var showExportSheet: Bool = false

    /// The timestamp of the most recent log fetch operation.
    @State
    private var lastFetch: Date = .distantPast

    /// Creates a new log list screen.
    public init() {}

    public var body: some View {
        List {
            InformationCell(lastFetch: $lastFetch)

            ForEach(logManager.logs) { log in
                LogCell(log: log)
            }
        }
        .navigationTitle("Logs")

        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif

        .onAppear(perform: fetchLogs)
        .refreshable(action: fetchLogs)
        .overlay(alignment: .center) { Overlay() }
        .toolbar {
            Toolbar(
                showFilterSheet: $showFilterSheet,
                showExportSheet: $showExportSheet
            )
        }
        .sheet(isPresented: $showFilterSheet) {
            if !logManager.hasValidResults {
                fetchLogs()
            }
        } content: {
            FilterSheet()
                .environment(logManager)
        }
        .sheet(isPresented: $showExportSheet) {
            ExportSheet()
                .environment(logManager)
        }
        .environment(logManager)
    }

    /// Fetches logs from the underlying logging system and updates the last fetch timestamp.
    private func fetchLogs() {
        logManager.fetch()
        self.lastFetch = .now
    }
}

extension LogListScreen {

    /// An overlay view that communicates loading and empty states for the log list.
    ///
    /// `Overlay` is displayed above the log list content and updates automatically based on the
    /// logger manager’s fetch and result state.
    private struct Overlay: View {

        /// The shared logger manager used to access log state.
        @Environment(LoggerManager.self)
        private var loggerManager

        var body: some View {
            if loggerManager.isFetching {
                ProgressView("Fetching logs...")
                    .controlSize(.extraLarge)
            }

            if loggerManager.logs.isEmpty && !loggerManager.isFetching {
                ContentUnavailableView(
                    "No logs",
                    systemImage: "text.page.badge.magnifyingglass",
                    description: Text("Try changing the filter settings to see more information.")
                )
            }
        }
    }
}

extension LogListScreen {

    /// Toolbar content providing access to filtering and exporting actions.
    ///
    /// The toolbar adapts its layout based on platform availability and ensures log data is
    /// available before initiating export.
    private struct Toolbar: ToolbarContent {

        /// The shared logger manager used to access log state.
        @Environment(LoggerManager.self)
        private var loggerManager

        /// Controls presentation of the filter sheet.
        @Binding
        var showFilterSheet: Bool

        /// Controls presentation of the export sheet.
        @Binding
        var showExportSheet: Bool

        var body: some ToolbarContent {
            ToolbarItem(placement: .primaryAction) {
                Button("Filter", systemImage: "line.3.horizontal.decrease") {
                    showFilterSheet.toggle()
                }
            }

            if #available(iOS 26.0, macOS 26.0, *) {
                ToolbarSpacer(placement: .primaryAction)
            }

            ToolbarItem(placement: .primaryAction) {
                Button("Export", systemImage: "square.and.arrow.up") {
                    if loggerManager.logs.isEmpty {
                        loggerManager.fetch()
                    }
                    showExportSheet.toggle()
                }
            }
        }
    }
}
