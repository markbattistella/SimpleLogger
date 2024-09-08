//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Security and Permissions
extension LoggerCategory {

    /// Logger category for security-related logs.
    public static let security = LoggerCategory("Security")

    /// Logger category for encryption-related logs.
    public static let encryption = LoggerCategory("Encryption")

    /// Logger category for decryption-related logs.
    public static let decryption = LoggerCategory("Decryption")

    /// Logger category for permissions-related logs.
    public static let permissions = LoggerCategory("Permissions")

    /// Logger category for authentication-related logs.
    public static let authentication = LoggerCategory("Authentication")

    /// Logger category for authorization-related logs.
    public static let authorization = LoggerCategory("Authorization")
}
