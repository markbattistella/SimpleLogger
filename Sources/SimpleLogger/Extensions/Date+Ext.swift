//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension Date {
    
    /// Creates a `Date` with the specified hour and minute, keeping the year, month, and day
    /// of the current date.
    ///
    /// - Parameters:
    ///   - hour: The hour component to set (0-23).
    ///   - minute: The minute component to set (0-59).
    /// - Returns: An optional `Date` with the specified time set, or `nil` if the operation fails.
    internal func createDateTime(hour: Int, minute: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) // Returns nil if date creation fails.
    }
}
