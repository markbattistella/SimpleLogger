//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import UniformTypeIdentifiers
import OSLog

// MARK: - Setup

/// A class responsible for managing and filtering OS log entries.
///
/// The `LoggerManager` class allows you to fetch, filter, and export logs from the OS log system.
/// It provides various filtering options such as date ranges, specific hours, log levels, and
/// categories. The class also manages the state of log exporting operations.
public final class LoggerManager: ObservableObject {

    /// A collection of OS log entries currently managed by the logger.
    @Published public var logs: [OSLogEntryLog] = []

    /// A boolean flag to determine whether to exclude system logs.
    @Published public var excludeSystemLogs: Bool

    /// The current filter type used to narrow down log entries.
    @Published public var filterType: FilterType

    /// A set of log levels to filter the log entries.
    @Published public var logLevels: Set<OSLogEntryLog.Level> = []

    /// A set of categories to filter the log entries.
    @Published public var categoryFilters: Set<String> = []

    /// The specific date to filter logs when `filterType` is set to `.specificDate`.
    @Published public var specificDate: Date

    /// The start date for filtering logs when `filterType` is set to `.dateRange`.
    @Published public var dateRangeStart: Date

    /// The end date for filtering logs when `filterType` is set to `.dateRange`.
    @Published public var dateRangeFinish: Date

    /// The start time for filtering logs when `filterType` is set to `.hourRange`.
    @Published public var hourRangeStart: Date

    /// The end time for filtering logs when `filterType` is set to `.hourRange`.
    @Published public var hourRangeFinish: Date

    /// The preset option for filtering logs when `filterType` is set to `.preset`.
    @Published public var selectedPreset: Preset

    /// The current state of the export process for logs.
    @Published public var exportState: ExportState

    /// Define allowed UTTypes
    private let allowedTypes: [UTType] = [.log, .json, .plainText, .text, .commaSeparatedText]

    /// The accessible file extensions allowed.
    @Published public private(set) var exportFileExtensions: [UTType]

    /// Initializes a new instance of `LoggerManager` with configurable options.
    ///
    /// - Parameters:
    ///   - excludeSystemLogs: A flag to exclude system logs from the fetched results.
    ///   - filterType: The type of filter to apply to the log entries.
    ///   - specificDate: The specific date to filter logs if `filterType` is `.specificDate`.
    ///   - dateRangeStart: The start date for filtering logs if `filterType` is `.dateRange`.
    ///   - dateRangeFinish: The end date for filtering logs if `filterType` is `.dateRange`.
    ///   - hourRangeStart: The start time for filtering logs if `filterType` is `.hourRange`.
    ///   - hourRangeFinish: The end time for filtering logs if `filterType` is `.hourRange`.
    ///   - selectedPreset: The preset option to filter logs if `filterType` is `.preset`.
    ///   - exportState: The initial state of the export process.
    ///   - logLevels: A set of log levels to filter the logs.
    ///   - categoryFilters: A set of categories to filter the logs.
    public init(
        excludeSystemLogs: Bool = true,
        filterType: FilterType = .specificDate,
        specificDate: Date = Date(),
        dateRangeStart: Date = Date(),
        dateRangeFinish: Date = Date(),
        hourRangeStart: Date = Date().addingTimeInterval(-3600),
        hourRangeFinish: Date = Date(),
        selectedPreset: Preset = .minutesFive,
        exportState: ExportState = .ready,
        logLevels: Set<OSLogEntryLog.Level> = [],
        categoryFilters: Set<String> = []
    ) {
        self.excludeSystemLogs = excludeSystemLogs
        self.filterType = filterType
        self.specificDate = specificDate
        self.dateRangeStart = dateRangeStart
        self.dateRangeFinish = dateRangeFinish
        self.hourRangeStart = hourRangeStart
        self.hourRangeFinish = hourRangeFinish
        self.selectedPreset = selectedPreset
        self.exportState = exportState
        self.logLevels = logLevels
        self.categoryFilters = categoryFilters

        self.exportFileExtensions = allowedTypes
    }
}

// MARK: - Enums

extension LoggerManager {

    /// An enumeration representing the state of the export process.
    ///
    /// This enum tracks the different states that the log export process can be in, such as being
    /// ready to start, currently processing, completed successfully, or failed.
    public enum ExportState {

        /// The export process is ready to start.
        case ready

        /// The export process is currently in progress.
        case processing

        /// The export process completed successfully.
        case completed

        /// The export process failed.
        case failed
    }

    /// A Boolean property that indicates whether the export process is currently in progress.
    public var isExporting: Bool {
        exportState == .processing
    }

    /// An enumeration that defines the various filter types for log entries.
    ///
    /// This enum provides different options for filtering log entries based on specific criteria,
    /// such as a specific date, a date range, an hour range, or preset time intervals.
    public enum FilterType: CustomStringConvertible, CaseIterable {

        /// Filter logs by a specific date.
        case specificDate

        /// Filter logs within a specified date range.
        case dateRange

        /// Filter logs within a specified hour range of the day.
        case hourRange

        /// Filter logs using predefined time presets.
        case preset

        /// A human-readable description of the filter type.
        public var description: String {
            switch self {
                case .specificDate: return "Specific date"
                case .dateRange: return "Date range"
                case .hourRange: return "Time range"
                case .preset: return "Preset options"
            }
        }
    }

    /// An enumeration representing preset time intervals for filtering logs.
    ///
    /// This enum provides options to filter log entries based on predefined time intervals,
    /// ranging from a few minutes to 24 hours.
    public enum Preset: CustomStringConvertible, CaseIterable {

        /// A 5-minute interval.
        case minutesFive

        /// A 10-minute interval.
        case minutesTen

        /// A 15-minute interval.
        case minutesFifteen

        /// A 30-minute interval.
        case minutesThirty

        /// A 1-hour interval.
        case hourOne

        /// A 6-hour interval.
        case hoursSix

        /// A 12-hour interval.
        case hoursTwelve

        /// A 24-hour interval.
        case hoursTwentyFour

        /// A human-readable description of the preset interval.
        public var description: String {
            switch self {
                case .minutesFive: return "5 minutes"
                case .minutesTen: return "10 minutes"
                case .minutesFifteen: return "15 minutes"
                case .minutesThirty: return "30 minutes"
                case .hourOne: return "1 hour"
                case .hoursSix: return "6 hours"
                case .hoursTwelve: return "12 hours"
                case .hoursTwentyFour: return "24 hours"
            }
        }

        /// The date corresponding to the preset time interval, calculated as the current date
        /// minus the interval duration.
        internal var presetDate: Date {
            return Date().addingTimeInterval(-timeInterval)
        }

        /// The duration in seconds corresponding to each preset time interval.
        private var timeInterval: TimeInterval {
            let minute: TimeInterval = 60
            let hour: TimeInterval = 3600
            switch self {
                case .minutesFive: return 5 * minute
                case .minutesTen: return 10 * minute
                case .minutesFifteen: return 15 * minute
                case .minutesThirty: return 30 * minute
                case .hourOne: return hour
                case .hoursSix: return 6 * hour
                case .hoursTwelve: return 12 * hour
                case .hoursTwentyFour: return 24 * hour
            }
        }
    }
}

// MARK: - Errors

extension LoggerManager {

    /// An enumeration representing errors that can occur within the `LoggerManager`.
    ///
    /// The `LoggerError` enum defines specific error cases that can be thrown by the
    /// `LoggerManager` during log fetching and file writing operations. Each error case includes
    /// a localized description to provide user-friendly error messages.
    internal enum LoggerError: Error, LocalizedError {

        /// An error indicating that fetching logs has failed.
        case failedToFetch

        /// An error indicating that writing the log file has failed.
        case failedToWriteFile

        /// An error indicating that the selected UTType is not allowed.
        case unsupportedFormatType

        /// A localized description of the error, suitable for display to the user.
        ///
        /// This property provides a human-readable error message for each specific error case,
        /// making it easier to understand what went wrong during the operation.
        var errorDescription: String? {
            switch self {
                case .failedToFetch:
                    return NSLocalizedString(
                        "Failed to fetch logs.",
                        comment: "Failed to fetch logs.")
                case .failedToWriteFile:
                    return NSLocalizedString(
                        "Failed to write log file.",
                        comment: "Failed to write log file.")
                case .unsupportedFormatType:
                    return NSLocalizedString(
                        "Unsupported filed type selected - only .log, .plaintext, .commaSeparatedValue, or .json are allowed.",
                        comment: "Unsupported filed type selected.")
            }
        }
    }
}

// MARK: - Public methods

extension LoggerManager {

    /// Asynchronously fetches log entries based on the current filter settings.
    ///
    /// This method retrieves log entries from the OS log store using the specified filter
    /// criteria, such as date ranges, log levels, and categories. It updates the `logs` property
    /// with the filtered results and sets the `exportState` to indicate the success or failure
    /// of the operation.
    ///
    /// - Throws: A `LoggerError.failedToFetch` error if fetching the logs fails.
    @MainActor
    public func fetchLogEntries() async throws {
        self.exportState = .processing
        let logPredicate: NSPredicate? = getLogPredicate()
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let entries = try store
                .getEntries(matching: logPredicate)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { log in
                    if excludeSystemLogs && log.subsystem != Bundle.main.bundleIdentifier {
                        return false
                    }
                    if !logLevels.isEmpty && !logLevels.contains(log.level) {
                        return false
                    }
                    if !categoryFilters.isEmpty && !categoryFilters.contains(log.category) {
                        return false
                    }
                    return true
                }

            await MainActor.run {
                self.logs = entries
                self.exportState = entries.isEmpty ? .failed : .completed
            }
        } catch {
            await MainActor.run {
                self.exportState = .failed
                self.logs = []
            }
            throw LoggerError.failedToFetch
        }
    }

    /// Exports the current logs into the specified format.
    ///
    /// This method converts the logs into the specified export format, such as plain text, JSON,
    /// or CSV with a specified delimiter. It returns the logs as a formatted string.
    ///
    /// - Parameter format: The format in which to export the logs.
    /// - Returns: A `String` representation of the logs in the specified format.
    public func exportLogs(as format: UTType, csvDelimiter: Delimiter = .comma) -> String {
        guard exportFileExtensions.contains(format) else {
            return "Unsupported export format."
        }

        switch format {
            case .json:
                return logEntriesToJSON(logEntries: logs)
            case .commaSeparatedText:
                return logEntriesToCSV(logEntries: logs, delimiter: csvDelimiter)
            case .plainText, .log:
                return logEntriesToString(logEntries: logs)
            default:
                return ""
        }
    }

    /// Writes the exported logs to a file at the specified URL in the chosen format.
    ///
    /// This method exports the logs in the specified format and writes them to a file at the
    /// given URL. If the writing process is successful, the `exportState` is updated to
    /// `.completed`. If an error occurs while writing the file, the `exportState` is updated to
    /// `.failed`, and the method throws a `LoggerError.failedToWriteFile`.
    ///
    /// - Parameters:
    ///   - format: The format in which to export the logs.
    ///   - url: The file URL where the logs should be written.
    /// - Throws: A `LoggerError.failedToWriteFile` error if writing the logs to the file fails.
    @MainActor
    public func writeLogs(as format: UTType, to url: URL) async throws {
        guard exportFileExtensions.contains(format) else {
            throw LoggerError.unsupportedFormatType
        }

        let logString = exportLogs(as: format)
        do {
            try logString.write(to: url, atomically: true, encoding: .utf8)
            await MainActor.run {
                self.exportState = .completed
            }
        } catch {
            await MainActor.run {
                self.exportState = .failed
            }
            throw LoggerError.failedToWriteFile
        }
    }
}

// MARK: - Helper methods

extension LoggerManager {

    /// Creates an `NSPredicate` based on the current filter type and settings.
    ///
    /// This method generates an appropriate predicate to filter log entries according to the
    /// selected filter type, such as a specific date, date range, hour range, or preset interval.
    ///
    /// - Returns: An optional `NSPredicate` that can be used to filter log entries, or `nil` if
    /// the predicate cannot be constructed (e.g., if hour range dates are invalid).
    private func getLogPredicate() -> NSPredicate? {
        switch filterType {
            case .specificDate:
                return datePredicate(for: specificDate)
            case .dateRange:
                return datePredicate(from: dateRangeStart, to: dateRangeFinish)
            case .hourRange:
                guard let (startDate, endDate) = getHourRangeDates() else { return nil }
                return datePredicate(from: startDate, to: endDate)
            case .preset:
                let startDate = selectedPreset.presetDate
                return datePredicate(from: startDate)
        }
    }

    /// Computes the start and end dates based on the specified hour range.
    ///
    /// This method creates `Date` objects representing the start and end of the hour range for the
    /// currently selected specific date. It adjusts the specific date with the start and finish
    /// hours and minutes specified in `hourRangeStart` and `hourRangeFinish`.
    ///
    /// - Returns: A tuple containing the start and end dates, or `nil` if the dates could not
    /// be created.
    private func getHourRangeDates() -> (startDate: Date, endDate: Date)? {
        let startHour = Calendar.current.component(.hour, from: hourRangeStart)
        let startMinute = Calendar.current.component(.minute, from: hourRangeStart)
        let finishHour = Calendar.current.component(.hour, from: hourRangeFinish)
        let finishMinute = Calendar.current.component(.minute, from: hourRangeFinish)

        guard let startDate = specificDate.createDateTime(hour: startHour, minute: startMinute),
              let endDate = specificDate.createDateTime(hour: finishHour, minute: finishMinute) else {
            return nil
        }
        return (startDate, endDate)
    }

    /// Creates an `NSPredicate` for filtering logs on a specific date.
    ///
    /// This method generates a predicate that filters logs occurring on the specified date,
    /// considering the full day from the start of the date to the start of the next day.
    ///
    /// - Parameter date: The specific date to filter logs.
    /// - Returns: An `NSPredicate` that filters logs to those occurring on the specified date.
    private func datePredicate(for date: Date) -> NSPredicate {
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
            return NSPredicate(value: false)
        }
        return NSPredicate(
            format: "date >= %@ AND date < %@",
            date as NSDate,
            nextDay as NSDate)
    }

    /// Creates an `NSPredicate` for filtering logs within a date range.
    ///
    /// This method generates a predicate that filters logs occurring within the specified date
    /// range. If only a start date is provided, logs from that start date onwards are included.
    ///
    /// - Parameters:
    ///   - startDate: The start date for filtering logs.
    ///   - endDate: The optional end date for filtering logs. If `nil`, logs are filtered from
    ///   the start date onwards.
    /// - Returns: An `NSPredicate` that filters logs within the specified date range.
    private func datePredicate(from startDate: Date, to endDate: Date? = nil) -> NSPredicate {
        if let endDate = endDate {
            return NSPredicate(
                format: "date >= %@ AND date <= %@",
                startDate as NSDate,
                endDate as NSDate)
        } else {
            return NSPredicate(
                format: "date >= %@",
                startDate as NSDate)
        }
    }

    /// Converts log entries into a formatted plain text string.
    ///
    /// This method takes an array of log entries and converts them into a string format,
    /// where each log entry is represented on a new line with fields separated by pipes (`|`).
    /// The message field is escaped to prevent conflicts with the delimiter.
    ///
    /// - Parameter logEntries: The log entries to be converted into a string.
    /// - Returns: A plain text string representation of the log entries.
    private func logEntriesToString(logEntries: [OSLogEntryLog]) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let logStrings = logEntries.map { entry in
            let date = dateFormatter.string(from: entry.date)
            let level = String(describing: entry.level)
            let subsystem = entry.subsystem
            let category = entry.category
            let message = entry.composedMessage.replacingOccurrences(of: "|", with: "\\|")
            return "\(date) | \(level) | \(subsystem) | \(category) | \(message)"
        }
        return logStrings.joined(separator: "\n")
    }

    /// Converts log entries into a JSON string format.
    ///
    /// This method encodes an array of log entries into a JSON string using the `JSONEncoder`.
    /// The output is formatted in a pretty-printed style for readability.
    ///
    /// - Parameter logEntries: The log entries to be converted into JSON format.
    /// - Returns: A JSON string representation of the log entries, or an empty string if encoding
    /// fails.
    private func logEntriesToJSON(logEntries: [OSLogEntryLog]) -> String {
        let logRepresentations = logEntries.map { LogRepresentation(entry: $0) }
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        if let jsonData = try? jsonEncoder.encode(logRepresentations),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return ""
    }

    /// Converts log entries into a CSV string format with a specified delimiter.
    ///
    /// This method takes an array of log entries and converts them into a CSV format, with fields 
    /// separated by the specified delimiter. Each field value is escaped to prevent conflicts
    /// with the delimiter.
    ///
    /// - Parameters:
    ///   - logEntries: The log entries to be converted into CSV format.
    ///   - delimiter: The delimiter to use for separating fields in the CSV output.
    /// - Returns: A CSV string representation of the log entries, including headers.
    private func logEntriesToCSV(logEntries: [OSLogEntryLog], delimiter: Delimiter) -> String {
        let headers = ["Date", "Level", "Subsystem", "Category", "Message"]
        let csvHeaders = headers.joined(separator: delimiter.rawValue)

        let csvStrings = logEntries.map { entry in
            let date = ISO8601DateFormatter().string(from: entry.date)
            let level = entry.level.description
            let subsystem = delimiter.escape(entry.subsystem)
            let category = delimiter.escape(entry.category)
            let message = delimiter.escape(entry.composedMessage)

            return [date, level, subsystem, category, message]
                .joined(separator: delimiter.rawValue)
        }
        return ([csvHeaders] + csvStrings).joined(separator: "\n")
    }
}

// MARK: - OSLogEntryLog Extension for Exporting

extension OSLogEntryLog {

    /// A dictionary representation of the log entry.
    ///
    /// This computed property provides a dictionary that represents the log entry, making it
    /// easy to convert the log entry into a format suitable for JSON encoding or other types of
    /// serialization. The dictionary includes the date, level, subsystem, category, and message
    /// of the log entry.
    ///
    /// - Returns: A dictionary with the log entry's details, including the date formatted as 
    /// an ISO 8601 string.
    internal var dictionaryRepresentation: [String: Any] {
        [
            "date": ISO8601DateFormatter().string(from: date),
            "level": level.description,
            "subsystem": subsystem,
            "category": category,
            "message": composedMessage
        ]
    }
}

fileprivate struct LogRepresentation: Encodable {

    /// The date of the log entry, formatted as an ISO 8601 string.
    let date: String

    /// The log level of the entry, represented as a string.
    let level: String

    /// The subsystem associated with the log entry.
    let subsystem: String

    /// The category of the log entry.
    let category: String

    /// The message content of the log entry.
    let message: String

    /// Initializes a new instance of `LogRepresentation` from an `OSLogEntryLog` entry.
    ///
    /// This initializer extracts and formats the relevant properties from the log entry,
    /// including formatting the date as an ISO 8601 string and converting the log level to a
    /// string description.
    ///
    /// - Parameter entry: The `OSLogEntryLog` instance to convert into a `LogRepresentation`.
    init(entry: OSLogEntryLog) {
        let dateFormatter = ISO8601DateFormatter()
        self.date = dateFormatter.string(from: entry.date)
        self.level = entry.level.description
        self.subsystem = entry.subsystem
        self.category = entry.category
        self.message = entry.composedMessage
    }
}
