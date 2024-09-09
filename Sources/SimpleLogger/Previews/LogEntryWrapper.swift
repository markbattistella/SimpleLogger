//
// Project: 
// Author: Mark Battistella
// Website: https://markbattistella.com
//

#if DEBUG

import Foundation
import OSLog

// MARK: - LogEntry protocol

/// A protocol representing a log entry, which includes details such as the date, log level,
/// subsystem, category, and composed message. Conforming types must also be identifiable and
/// hashable.
internal protocol LogEntry: Identifiable, Hashable {

    /// The date and time when the log entry was created.
    var date: Date { get }

    /// The log level of the entry, such as `info`, `debug`, `error`, etc.
    var level: OSLogEntryLog.Level { get }

    /// The subsystem associated with the log entry, which typically represents a module or component.
    var subsystem: String { get }

    /// The category of the log entry, used to further classify the log messages.
    var category: String { get }

    /// The composed message of the log entry, which includes the log content.
    var composedMessage: String { get }
}

// MARK: - OSLogEntryLog extension

/// Extends `OSLogEntryLog` to conform to the `LogEntry` protocol, allowing it to be used where
/// `LogEntry` is expected.
extension OSLogEntryLog: LogEntry {}

// MARK: - LogEntryWrapper

/// A wrapper enum that conforms to `LogEntry`, allowing it to encapsulate both mock and real log
/// entries.
///
/// This enum provides a unified interface to work with log entries, whether they are real logs 
/// from the system or mock logs used for testing and development purposes.
internal enum LogEntryWrapper: LogEntry, Identifiable, Hashable {

    /// A mock log entry, typically used for testing and simulation.
    case mock(MockOSLogEntryLog)

    /// A real log entry from the system.
    case real(OSLogEntryLog)

    /// A unique identifier for the log entry.
    var id: UUID {
        switch self {
            case .mock(let log):
                return log.id
            case .real(let log):
                return UUID()
        }
    }

    /// The date and time when the log entry was created.
    var date: Date {
        switch self {
            case .mock(let log):
                return log.date
            case .real(let log):
                return log.date
        }
    }

    /// The log level of the entry.
    var level: OSLogEntryLog.Level {
        switch self {
            case .mock(let log):
                return log.level
            case .real(let log):
                return log.level
        }
    }

    /// The subsystem associated with the log entry.
    var subsystem: String {
        switch self {
            case .mock(let log):
                return log.subsystem
            case .real(let log):
                return log.subsystem
        }
    }

    /// The category of the log entry.
    var category: String {
        switch self {
            case .mock(let log):
                return log.category
            case .real(let log):
                return log.category
        }
    }

    /// The composed message of the log entry.
    var composedMessage: String {
        switch self {
            case .mock(let log):
                return log.composedMessage
            case .real(let log):
                return log.composedMessage
        }
    }
}

#endif
