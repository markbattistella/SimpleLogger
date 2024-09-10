//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Testing and Validation

extension LoggerCategory {

    /// Logger category for testing-related logs.
    public static let testing = LoggerCategory("Testing")

    /// Logger category for unit testing-related logs.
    public static let unitTesting = LoggerCategory("UnitTesting")

    /// Logger category for integration testing-related logs.
    public static let integrationTesting = LoggerCategory("IntegrationTesting")

    /// Logger category for UI testing-related logs.
    public static let uiTesting = LoggerCategory("UITesting")

    /// Logger category for mocking-related logs.
    public static let mocking = LoggerCategory("Mocking")

    /// Logger category for stubbing-related logs.
    public static let stubbing = LoggerCategory("Stubbing")

    /// Logger category for validation-related logs.
    public static let validation = LoggerCategory("Validation")
}
