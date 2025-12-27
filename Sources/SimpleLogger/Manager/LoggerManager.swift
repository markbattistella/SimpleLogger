//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import Observation

/// Manages the lifecycle of log querying, filtering, fetching, and exporting.
///
/// `LoggerManager` is an observable, main-actor–isolated object intended to be consumed by UI
/// layers. It maintains filter state, executes log fetches with cancellation support, and exposes
/// derived state such as loading progress, validity of results, and errors.
///
/// Any change to filter-related properties automatically invalidates the current results and
/// cancels any in-flight fetch.
@Observable
public final class LoggerManager {

    /// Internal reader responsible for executing log queries.
    @ObservationIgnored
    private let reader = LoggerReader()

    /// The currently running fetch task, if any.
    ///
    /// Used to cancel in-flight requests when filters change or a new fetch begins.
    @ObservationIgnored
    private var fetchTask: Task<Void, Never>?

    /// The most recently fetched logs.
    public private(set) var logs: [LoggerRepresentation] = []

    /// Indicates whether a fetch operation is currently in progress.
    public private(set) var isFetching = false

    /// The most recent error encountered during fetch or export operations.
    public var lastError: LoggerManagerError?

    /// Indicates whether the current `logs` reflect a valid, completed fetch for the current
    /// filter configuration.
    public private(set) var hasValidResults: Bool = false

    /// The active filter kind used to determine how log scope is resolved.
    public var kind: Filter.Kind = .specificDate {
        didSet { invalidate() }
    }

    /// The date used when `kind` is `.specificDate`.
    public var specificDate: Date = .now {
        didSet { invalidate() }
    }

    /// The start date used when `kind` is `.dateRange`.
    public var dateRangeStart: Date = .now {
        didSet { invalidate() }
    }

    /// The end date used when `kind` is `.dateRange`.
    public var dateRangeEnd: Date = .now {
        didSet { invalidate() }
    }

    /// The base date used when resolving an hourly range.
    ///
    /// The actual start and end times are derived using `hourRangeStartHour` and
    /// `hourRangeEndHour`.
    public var hourRangeDate: Date = .now {
        didSet { invalidate() }
    }

    /// The starting hour (0–23) for an hourly range filter.
    public var hourRangeStartHour: Int = 0 {
        didSet { invalidate() }
    }

    /// The ending hour (1–24) for an hourly range filter.
    ///
    /// A value of `24` represents midnight of the following day.
    public var hourRangeEndHour: Int = 24 {
        didSet { invalidate() }
    }

    /// The preset filter used when `kind` is `.preset`.
    public var preset: Filter.Preset = .lastFiveMinutes {
        didSet { invalidate() }
    }

    /// The set of log levels included in the query.
    ///
    /// Defaults to all available log levels.
    public var levels: Set<LogLevel> = Set(LogLevel.allCases) {
        didSet { invalidate() }
    }

    /// Indicates whether system-generated logs should be excluded.
    public var excludeSystemLogs: Bool = true {
        didSet { invalidate() }
    }

    /// Creates a new `LoggerManager` with default filter settings.
    public init() {}

    /// Invalidates the current results and cancels any active fetch.
    ///
    /// This is invoked automatically whenever filter-related state changes.
    private func invalidate() {
        fetchTask?.cancel()
        hasValidResults = false
    }
}

extension LoggerManager {

    /// Resolves the current filter configuration into a concrete log scope.
    ///
    /// Returns `nil` if the current filter state is invalid (for example, an inverted date range
    /// or an invalid hour range).
    private var resolvedScope: Filter.Scope? {
        switch kind {
            case .specificDate:
                return .specificDate(specificDate)

            case .dateRange:
                guard dateRangeStart <= dateRangeEnd else { return nil }
                return .dateRange(from: dateRangeStart, to: dateRangeEnd)

            case .hourRange:
                guard let (start, end) = resolveHourRange() else { return nil }
                return .hourRange(from: start, to: end)

            case .preset:
                return .preset(preset)
        }
    }

    /// Resolves the current hour-range configuration into concrete start and end dates.
    ///
    /// The returned dates are aligned to hour boundaries. An end hour of `24` represents midnight
    /// of the following day.
    ///
    /// - Returns: A tuple containing the start and end dates, or `nil` if the hour range
    /// configuration is invalid.
    private func resolveHourRange() -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        let day = calendar.startOfDay(for: hourRangeDate)

        guard
            (0...23).contains(hourRangeStartHour),
            (1...24).contains(hourRangeEndHour),
            hourRangeStartHour < hourRangeEndHour
        else { return nil }

        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: day),
              let start = calendar.date(
                bySettingHour: hourRangeStartHour,
                minute: 0,
                second: 0,
                of: day
              )
        else { return nil }

        let endBase = hourRangeEndHour == 24 ? nextDay : day

        guard let end = calendar.date(
            bySettingHour: hourRangeEndHour % 24,
            minute: 0,
            second: 0,
            of: endBase
        )
        else { return nil }

        return (start, end)
    }
}

extension LoggerManager {

    /// Fetches logs matching the current filter configuration.
    ///
    /// Any in-flight fetch is cancelled before starting a new one. If the current filter
    /// configuration cannot be resolved into a valid scope, the fetch is aborted and `isFetching`
    /// is reset.
    ///
    /// On success, `logs` and `hasValidResults` are updated.
    /// On failure, `lastError` is set and results are cleared.
    @MainActor
    public func fetch() {
        fetchTask?.cancel()

        self.isFetching = true
        self.lastError = nil

        guard let scope = resolvedScope else {
            self.isFetching = false
            return
        }

        let query = LoggerQuery(
            scope: scope,
            excludeSystemLogs: excludeSystemLogs,
            levels: levels
        )

        fetchTask = Task {
            do {
                let results = try await reader.fetch(query: query)
                guard !Task.isCancelled else { return }

                self.logs = results
                self.hasValidResults = true
                self.isFetching = false

            } catch {
                guard !Task.isCancelled else { return }

                self.logs = []
                self.isFetching = false
                self.hasValidResults = false
                self.lastError = .fetch(error)
            }
        }
    }
}

extension LoggerManager {

    /// Exports the currently loaded logs in the specified format.
    ///
    /// The export work is performed asynchronously on a background thread to avoid blocking
    /// the caller. On success, the exported data is returned. On failure, the error is captured
    /// in ``lastError`` and returned as a `.failure` result.
    ///
    /// This method does not throw. Callers are expected to handle success or failure via the
    /// returned `Result` value, or observe ``lastError`` for UI presentation.
    ///
    /// - Parameter format: The export format to use.
    /// - Returns: A `Result` containing the exported `Data` on success, or a
    ///   ``LoggerManagerError`` describing the failure.
    public func export(format: Export.Format) async -> Result<Data, LoggerManagerError> {
        self.lastError = nil

        do {
            let data = try await LoggerExporter.export(logs: logs, as: format)
            return .success(data)
        } catch {
            let managerError = LoggerManagerError.export(error)
            self.lastError = managerError
            return .failure(managerError)
        }
    }
}

extension LoggerManager {

    /// Errors produced by `LoggerManager` operations.
    public enum LoggerManagerError: Error, Identifiable, LocalizedError {

        /// An error occurred while fetching logs.
        case fetch(Error)

        /// An error occurred while exporting logs.
        case export(Error)

        /// A stable identifier for use in SwiftUI or other identity-based contexts.
        public var id: String {
            switch self {
                case .fetch: "fetch"
                case .export: "export"
            }
        }

        /// A human-readable description of the error suitable for display to the user.
        public var errorDescription: String? {
            switch self {
                case .fetch(let error):
                    return "Failed to fetch logs.\n\(error.localizedDescription)"

                case .export(let error):
                    return "Failed to export logs.\n\(error.localizedDescription)"
            }
        }
    }
}
