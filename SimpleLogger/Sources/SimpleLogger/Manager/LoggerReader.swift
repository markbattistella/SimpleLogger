//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// An actor responsible for reading and filtering log entries from the unified logging system.
internal actor LoggerReader {

    /// Fetches log entries matching the provided query.
    ///
    /// This method reads from the current process’s unified log store, applies a date range,
    /// filters by log level and subsystem, and converts matching entries into
    /// `LoggerRepresentation` values with stable identifiers.
    ///
    /// - Parameter query: A `LoggerQuery` describing the date window, log levels, and filtering options to apply.
    /// - Returns: An array of `LoggerRepresentation` values matching the query.
    /// - Throws: An error if the log store cannot be accessed or log entries cannot be read.
    internal func fetch(query: LoggerQuery) throws -> [LoggerRepresentation] {

        let store = try OSLogStore(scope: .currentProcessIdentifier)
        guard let range = query.dateWindow() else { return [] }

        let predicate = Self.makePredicate(from: range)
        var idGenerator = LoggerIDGenerator()

        return try store
            .getEntries(matching: predicate)
            .compactMap { $0 as? OSLogEntryLog }
            .filter { log in
                if query.excludeSystemLogs,
                   log.subsystem != subsystem {
                    return false
                }

                guard query.levels.contains(LogLevel(log.level)) else {
                    return false
                }

                return true
            }
            .map {
                LoggerRepresentation(
                    id: idGenerator.makeID(for: $0.date),
                    entry: $0
                )
            }
    }

    /// Creates an `NSPredicate` for filtering log entries by date.
    ///
    /// The predicate matches log entries whose `date` is greater than or equal to the start date,
    /// and optionally less than the end date if one is provided.
    ///
    /// - Parameter range: A tuple containing a required start date and an optional end date.
    /// - Returns: An `NSPredicate` suitable for querying an `OSLogStore`.
    private static func makePredicate(
        from range: (start: Date, end: Date?)
    ) -> NSPredicate {
        if let end = range.end {
            return NSPredicate(
                format: "date >= %@ AND date < %@",
                range.start as NSDate,
                end as NSDate
            )
        }
        return NSPredicate(
            format: "date >= %@",
            range.start as NSDate
        )
    }
}
