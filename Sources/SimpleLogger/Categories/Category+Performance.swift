//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Performance and Optimization

extension LoggerCategory {

    /// Logger category for performance-related logs.
    public static let performance = LoggerCategory("Performance")

    /// Logger category for memory management-related logs.
    public static let memoryManagement = LoggerCategory("MemoryManagement")

    /// Logger category for concurrency-related logs.
    public static let concurrency = LoggerCategory("Concurrency")

    /// Logger category for threading-related logs.
    public static let threading = LoggerCategory("Threading")

    /// Logger category for debugging-related logs.
    public static let debugging = LoggerCategory("Debugging")

    /// Logger category for monitoring-related logs.
    public static let monitoring = LoggerCategory("Monitoring")
}
