//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import SwiftUI

/// A generator for producing monotonically increasing log identifiers.
///
/// Identifiers are composed of a timestamp component (in microseconds) combined with a short
/// sequence counter to ensure uniqueness for entries created within the same microsecond.
internal struct LoggerIDGenerator {

    /// A rolling sequence counter used to disambiguate identical timestamps.
    private var sequence: UInt64 = 0

    /// Generates a unique identifier for a given date.
    ///
    /// The identifier encodes the number of microseconds since the Unix epoch in the upper bits,
    /// with a 16-bit sequence counter in the lower bits.
    ///
    /// - Parameter date: The date associated with the log entry.
    /// - Returns: A unique, time-ordered identifier.
    internal mutating func makeID(for date: Date) -> UInt64 {
        let micros = UInt64(date.timeIntervalSince1970 * 1_000_000)
        sequence &+= 1
        return (micros << 16) | (sequence & 0xFFFF)
    }
}

/// A protocol describing a log entry that can be displayed or listed.
///
/// Conforming types must provide identifying, temporal, and descriptive information about a log
/// entry and be safe for use across concurrency domains.
internal protocol LoggerViewable: Identifiable, Sendable {

    /// A unique identifier for the log entry.
    var id: UInt64 { get }

    /// The timestamp at which the log entry was recorded.
    var date: Date { get }

    /// The severity level of the log entry.
    var level: LogLevel { get }

    /// The logging subsystem associated with the entry.
    var subsystem: String { get }

    /// The logging category associated with the entry.
    var category: String { get }

    /// The formatted log message.
    var message: String { get }
}

/// A concrete, encodable representation of a log entry.
///
/// This type adapts `OSLogEntryLog` into a stable, serialisable form suitable for persistence,
/// export, or UI presentation.
public struct LoggerRepresentation: LoggerViewable, Encodable, Sendable {

    /// The unique identifier for the log entry.
    public let id: UInt64

    /// The timestamp at which the log entry was recorded.
    public let date: Date

    /// The severity level of the log entry.
    public let level: LogLevel

    /// The logging subsystem associated with the entry.
    public let subsystem: String

    /// The logging category associated with the entry.
    public let category: String

    /// The formatted log message.
    public let message: String

    /// Creates a logger representation from an OS log entry.
    ///
    /// - Parameters:
    ///   - id: A unique identifier generated for the entry.
    ///   - entry: The underlying `OSLogEntryLog` instance.
    internal init(
        id: UInt64,
        entry: OSLogEntryLog
    ) {
        self.id = id
        self.date = entry.date
        self.level = LogLevel(entry.level)
        self.subsystem = entry.subsystem
        self.category = entry.category
        self.message = entry.composedMessage
    }
}

#if DEBUG

extension LoggerRepresentation {

    /// Convenience initializer for SwiftUI previews and testing.
    public init(
        id: UInt64 = 0,
        date: Date = .now,
        level: LogLevel = .info,
        subsystem: String = "com.example.app",
        category: String = "Preview",
        message: String = "Preview log message"
    ) {
        self.id = id
        self.date = date
        self.level = level
        self.subsystem = subsystem
        self.category = category
        self.message = message
    }
}

#endif

/// A strongly typed representation of log severity levels.
///
/// This enum mirrors the severity levels defined by `OSLog`, while providing additional
/// UI-friendly metadata such as colours and system images.
public enum LogLevel: Int, Encodable, Sendable, CaseIterable, Identifiable {

    /// An unspecified or unknown log level.
    case undefined = 0

    /// Debug-level diagnostic information.
    case debug = 1

    /// Informational messages.
    case info = 2

    /// Notices that are neither errors nor purely informational.
    case notice = 3

    /// Recoverable error conditions.
    case error = 4

    /// Serious, unrecoverable faults.
    case fault = 5

    /// A stable identifier for use in SwiftUI collections.
    public var id: Int { rawValue }

    /// Creates a log level from an OS log entry level.
    ///
    /// - Parameter level: The `OSLogEntryLog.Level` value.
    internal init(_ level: OSLogEntryLog.Level) {
        self = LogLevel(rawValue: level.rawValue) ?? .undefined
    }

    /// A human-readable description of the log level.
    public var description: String {
        switch self {
            case .undefined: String(localized: "Undefined")
            case .debug: String(localized: "Debug")
            case .info: String(localized: "Info")
            case .notice: String(localized: "Notice")
            case .error: String(localized: "Error")
            case .fault: String(localized: "Fault")
        }
    }

    /// A colour suitable for visually representing the log level.
    public var color: Color {
        switch self {
            case .undefined: .gray
            case .debug: .green
            case .info: .blue
            case .notice: .cyan
            case .error: .orange
            case .fault: .red
        }
    }

    /// The name of an SF Symbols system image associated with the log level.
    public var systemImage: String {
        switch self {
            case .undefined: "exclamationmark"
            case .debug: "stethoscope"
            case .info: "info"
            case .notice: "bell"
            case .error: "exclamationmark.2"
            case .fault: "exclamationmark.3"
        }
    }
}
