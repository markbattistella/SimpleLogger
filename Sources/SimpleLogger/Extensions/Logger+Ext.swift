//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
@_exported import OSLog

/// A type alias for OSLog's Logger to provide a seamless experience when using SimpleLogger
public typealias SimpleLogger = Logger

extension Logger {

    /// Initializes a Logger with a specific category.
    ///
    /// - Parameter category: The `LoggerCategory` used for logging.
    public init(category: LoggerCategory) {

        // Safely handle bundle identifier and provide a default if nil
        let subsystem = Bundle.main.bundleIdentifier ?? "com.markbattistella.simple-logger"
        self.init(subsystem: subsystem, category: category.rawValue)
    }
}
