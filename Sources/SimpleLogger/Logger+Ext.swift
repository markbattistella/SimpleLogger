//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import OSLog

public extension Logger {

    /// Initializes a Logger with a specific category.
    ///
    /// - Parameter category: The `LoggerCategory` used for logging.
    init(category: LoggerCategory) {

        // Safely handle bundle identifier and provide a default if nil
        let subsystem = Bundle.main.bundleIdentifier ?? "com.markbattistella.simple-logger"
        self.init(subsystem: subsystem, category: category.rawValue)
    }
}
