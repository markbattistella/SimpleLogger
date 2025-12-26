//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A value that describes how log entries should be queried and filtered.
internal struct LoggerQuery {

    /// The scope that defines the date window used when querying logs.
    internal let scope: Filter.Scope

    /// A Boolean value indicating whether system log entries should be excluded.
    ///
    /// When `true`, only log entries originating from the current subsystem are included in the
    /// results.
    internal let excludeSystemLogs: Bool

    /// The set of log levels that are included in the query results.
    internal let levels: Set<LogLevel>

    /// Computes the date window used to constrain the log query.
    ///
    /// This method delegates to the underlying `scope` to determine the start date and optional
    /// end date for the query.
    ///
    /// - Returns: A tuple containing the start date and an optional end date,
    ///   or `nil` if the scope does not define a valid date window.
    internal func dateWindow() -> (start: Date, end: Date?)? {
        scope.dateWindow()
    }
}
