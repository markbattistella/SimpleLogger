//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import OSLog
import SwiftUI

extension OSLogEntryLog.Level: CustomStringConvertible {

    /// A textual representation of the log level.
    ///
    /// This property conforms to the `CustomStringConvertible` protocol,
    /// allowing each log level to be represented as a descriptive string.
    ///
    /// - Returns: A string describing the log level.
    public var description: String {
        switch self {
            case .undefined:
                return "Undefined"
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .notice:
                return "Notice"
            case .error:
                return "Error"
            case .fault:
                return "Fault"
            @unknown default:
                return "Unknown"
        }
    }

    /// A color representation associated with the log level.
    ///
    /// This property provides a color suitable for UI elements that display log entries.
    /// It uses predefined colors to visually differentiate log levels.
    ///
    /// - Returns: A `Color` value representing the log level
    public var color: Color {
        switch self {
            case .undefined:
                return .gray
            case .debug:
                return .green
            case .info:
                return .blue
            case .notice:
                return Color(AgnosticColor.predatedCyan)
            case .error:
                return .orange
            case .fault:
                return .red
            @unknown default:
                return .clear
        }
    }

    /// An SF Symbol name associated with the log level.
    ///
    /// This property maps each log level to an appropriate SF Symbol, which can be
    /// used in UI elements to visually represent the log severity.
    ///
    /// - Returns: A `String` containing the SF Symbol name corresponding to the log level
    public var sfSymbol: String {
        switch self {
            case .undefined:
                return "exclamationmark"
            case .debug:
                return "stethoscope"
            case .info:
                return "info"
            case .notice:
                return "bell.fill"
            case .error:
                return "exclamationmark.2"
            case .fault:
                return "exclamationmark.3"
            @unknown default:
                return "questionmark"
        }
    }
}
