//
// Project: 
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

extension TimeInterval {

    private static func getMinutes(_ minutes: Int) -> TimeInterval {
        TimeInterval(minutes * 60)
    }

    private static func getHours(_ hours: Int) -> TimeInterval {
        TimeInterval(hours * 60 * 60)
    }

    // MARK: - Predefined times

    internal static var minutesFive: TimeInterval {
        TimeInterval.getMinutes(5)
    }
    
    internal static var minutesTen: TimeInterval {
        TimeInterval.getMinutes(10)
    }

    internal static var minutesFifteen: TimeInterval {
        TimeInterval.getMinutes(15)
    }

    internal static var minutesThirty: TimeInterval {
        TimeInterval.getMinutes(30)
    }
    

    internal static var hoursOne: TimeInterval {
        TimeInterval.getHours(1)
    }

    internal static var hoursSix: TimeInterval {
        TimeInterval.getHours(6)
    }

    internal static var hoursTwelve: TimeInterval {
        TimeInterval.getHours(12)
    }
    
    internal static var hoursTwentyFour: TimeInterval {
        TimeInterval.getHours(24)
    }
}
