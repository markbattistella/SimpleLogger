//
// Project:
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

import Foundation
import OSLog

internal struct MockOSLogEntryLog: LogEntry {
    let id: UUID = UUID()
    let date: Date
    let level: OSLogEntryLog.Level
    let subsystem: String
    let category: String
    let composedMessage: String

    static let mockDataEmpty: [MockOSLogEntryLog] = []
    static let mockDataFull: [MockOSLogEntryLog] = [
        MockOSLogEntryLog(
            date: Date(),
            level: .undefined,
            subsystem: Bundle.main.bundleIdentifier!,
            category: "General",
            composedMessage: "An undefined event occurred. Please check the system logs for more details."
        ),
        MockOSLogEntryLog(
            date: Date(),
            level: .debug,
            subsystem: Bundle.main.bundleIdentifier!,
            category: "Debugging",
            composedMessage: "Debugging mode is active. Loaded 5 configuration files successfully."
        ),
        MockOSLogEntryLog(
            date: Date(),
            level: .notice,
            subsystem: Bundle.main.bundleIdentifier!,
            category: "System",
            composedMessage: "Notice: The application will undergo maintenance at midnight UTC."
        ),
        MockOSLogEntryLog(
            date: Date(),
            level: .error,
            subsystem: Bundle.main.bundleIdentifier!,
            category: "API",
            composedMessage: "Error encountered during data fetch: timeout occurred while connecting to the server. Retry in 5 seconds."
        ),
        MockOSLogEntryLog(
            date: Date(),
            level: .fault,
            subsystem: Bundle.main.bundleIdentifier!,
            category: "Networking",
            composedMessage: "Critical fault: Network interface failure detected. Immediate attention required to restore connectivity."
        ),
        MockOSLogEntryLog(
            date: Date(),
            level: .info,
            subsystem: Bundle.main.bundleIdentifier!,
            category: "Networking",
            composedMessage: "Successfully fetched 120 records from the server for user ID 4587 in 2.3 seconds. API endpoint: /users/data. No errors encountered during the fetch operation."
        )
    ]
}

#endif
