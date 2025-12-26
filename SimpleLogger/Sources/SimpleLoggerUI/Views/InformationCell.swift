//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

#Preview {
    Form {
        LogListScreen
            .InformationCell(lastFetch: .constant(Date()))
    }
    .environment(LoggerManager())
}

extension LogListScreen {
    
    /// A list section that displays metadata about the current log dataset.
    ///
    /// `InformationCell` provides contextual information such as the timestamp of the most
    /// recent fetch and the total number of logs currently loaded. The details are disclosed
    /// on demand to keep the list compact.
    internal struct InformationCell: View {
        
        /// The shared logger manager providing access to log data.
        @Environment(LoggerManager.self)
        private var logManager
        
        /// The timestamp of the most recent log fetch.
        @Binding
        var lastFetch: Date
        
        var body: some View {
            Section {
                DisclosureGroup("Fetched log information") {
                    LabeledContent(
                        "Last updated",
                        value: lastFetch,
                        format: .dateTime
                    )
                    LabeledContent(
                        "Total logs",
                        value: logManager.logs.count,
                        format: .number
                    )
                }
                .font(.footnote)
            }
        }
    }
}
