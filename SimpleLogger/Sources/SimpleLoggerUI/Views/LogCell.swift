//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

#Preview {
    Form {
        LogListScreen.LogCell(
            log: LoggerRepresentation(
                level: .error,
                subsystem: "com.markbattistella.package.SimpleLogger",
                category: LoggerCategory.network.rawValue,
                message: "Request failed with status code 500"
            )
        )
    }
    .environment(LoggerManager())
}

extension LogListScreen {

    /// A list row view that displays the details of a single log entry.
    ///
    /// `LogCell` presents a concise summary of a log, including its timestamp, severity level,
    /// subsystem, category, and message. Visual styling reflects the log level to improve
    /// scannability within a list.
    internal struct LogCell: View {

        /// The log entry represented by this cell.
        let log: LoggerRepresentation

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    Text(log.date, format: .iso8601)
                        .monospaced()
                    Spacer()
                    Text(log.level.description)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .frame(minWidth: 60, maxHeight: 26)
                        .background(log.level.color, in: .rect(cornerRadius: 8))
                }
                .padding(.bottom, 6)

                VStack(alignment: .leading) {
                    LabeledContent("Subsystem", value: log.subsystem)
                    LabeledContent("Category", value: log.category)
                    LabeledContent("Message", value: log.message)
                        .multilineTextAlignment(.leading)
                }
                .labeledContentStyle(.vertical)
            }
            .font(.caption)
            .listRowBackground(log.level.color.opacity(0.1))
            .listRowSeparatorTint(log.level.color, edges: .bottom)
            .listRowSeparatorTint(.clear, edges: .top)

        }
    }
}
