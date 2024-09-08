//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Data Management and Persistence
extension LoggerCategory {

    /// Logger category for Core Data-related logs.
    public static let coreData = LoggerCategory("CoreData")

    /// Logger category for Swift Data-related logs.
    public static let swiftData = LoggerCategory("SwiftData")

    /// Logger category for database-related logs.
    public static let database = LoggerCategory("Database")

    /// Logger category for caching-related logs.
    public static let caching = LoggerCategory("Caching")

    /// Logger category for persistence-related logs.
    public static let persistence = LoggerCategory("Persistence")

    /// Logger category for serialization-related logs.
    public static let serialization = LoggerCategory("Serialization")

    /// Logger category for deserialization-related logs.
    public static let deserialization = LoggerCategory("Deserialization")

    /// Logger category for parsing-related logs.
    public static let parsing = LoggerCategory("Parsing")

    /// Logger category for keychain-related logs.
    public static let keychain = LoggerCategory("Keychain")

    /// Logger category for UserDefaults-related logs.
    public static let userDefaults = LoggerCategory("UserDefaults")

    /// Logger category for backup-related logs.
    public static let backup = LoggerCategory("Backup")

    /// Logger category for restore-related logs.
    public static let restore = LoggerCategory("Restore")
}
