//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Utilities and Helpers

extension LoggerCategory {

    /// Logger category for utility-related logs.
    public static let utils = LoggerCategory("Utils")

    /// Logger category for extension-related logs.
    public static let extensions = LoggerCategory("Extensions")

    /// Logger category for helper-related logs.
    public static let helpers = LoggerCategory("Helpers")

    /// Logger category for factory-related logs.
    public static let factories = LoggerCategory("Factories")

    /// Logger category for builder-related logs.
    public static let builders = LoggerCategory("Builders")

    /// Logger category for command-related logs.
    public static let commands = LoggerCategory("Commands")

    /// Logger category for handler-related logs.
    public static let handlers = LoggerCategory("Handlers")

    /// Logger category for middleware-related logs.
    public static let middlewares = LoggerCategory("Middlewares")

    /// Logger category for interceptor-related logs.
    public static let interceptors = LoggerCategory("Interceptors")
}
