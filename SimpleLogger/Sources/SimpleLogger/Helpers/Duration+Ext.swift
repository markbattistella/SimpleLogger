//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

extension Duration {
    
    /// Creates a duration representing the specified number of minutes.
    ///
    /// - Parameter value: The number of minutes.
    /// - Returns: A `Duration` equal to the given number of minutes.
    internal static func minutes(_ value: Double) -> Duration {
        .seconds(value * 60)
    }
    
    /// Creates a duration representing the specified number of hours.
    ///
    /// - Parameter value: The number of hours.
    /// - Returns: A `Duration` equal to the given number of hours.
    internal static func hours(_ value: Double) -> Duration {
        .seconds(value * 3_600)
    }
    
    /// Creates a duration representing the specified number of days.
    ///
    /// - Parameter value: The number of days.
    /// - Returns: A `Duration` equal to the given number of days.
    internal static func days(_ value: Double) -> Duration {
        .seconds(value * 86_400)
    }
    
    /// Creates a duration representing the specified number of weeks.
    ///
    /// - Parameter value: The number of weeks.
    /// - Returns: A `Duration` equal to the given number of weeks.
    internal static func weeks(_ value: Double) -> Duration {
        .seconds(value * 604_800)
    }
    
    /// Converts the duration to a `TimeInterval`.
    ///
    /// This property combines the seconds and attoseconds components of the duration into a
    /// single `TimeInterval` value.
    internal var asTimeInterval: TimeInterval {
        let (seconds, attoseconds) = components
        return TimeInterval(seconds)
        + TimeInterval(attoseconds) / 1_000_000_000_000_000_000
    }
}
