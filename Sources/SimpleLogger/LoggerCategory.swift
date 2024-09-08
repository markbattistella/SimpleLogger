//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import OSLog

/// Protocol for Logger categories that conforms to `RawRepresentable`, `Hashable`, and
/// `Equatable`. The `rawValue` must be of type `String`.
fileprivate protocol LoggerCategoryRepresentable: RawRepresentable, Hashable, Equatable where RawValue == String {}

/// Actor responsible for managing and tracking logger categories.
internal actor LoggerCategoryManager {

    /// A set to track existing category raw values to prevent duplicates.
    private var existingRawValues = Set<String>()

    /// Checks if a category with the given value exists and adds it if not.
    ///
    /// - Parameter rawValue: The string value of the category.
    /// - Returns: A Boolean indicating whether the value was already present.
    func addCategoryIfNew(_ rawValue: String) -> Bool {
        let lowercasedValue = rawValue.lowercased()
        if existingRawValues.contains(lowercasedValue) {
            return true
        } else {
            existingRawValues.insert(lowercasedValue)
            return false
        }
    }
}

/// A structure representing a category for the Logger, ensuring uniqueness and preventing
/// duplicate categories.
public struct LoggerCategory: LoggerCategoryRepresentable, Sendable {

    /// String representation of the category.
    public let rawValue: String

    /// Shared actor instance for managing logger categories.
    private static let manager = LoggerCategoryManager()

    /// An internal category for warning logs related to LoggerCategory.
    private static let simpleLoggerPackage = LoggerCategory("SimpleLoggerPackage")

    /// Logger instance for internal plugin logs.
    private static let internalPlugin = Logger(category: .simpleLoggerPackage)

    /// Initializes a new LoggerCategory with a raw string value.
    /// Ensures that the category is unique by checking against existing categories.
    ///
    /// - Parameter rawValue: The string value of the category.
    public init(rawValue: String) {
        self.rawValue = rawValue
        Task {
            let exists = await LoggerCategory.manager.addCategoryIfNew(rawValue)
            if exists {
                LoggerCategory
                    .internalPlugin
                    .warning("LoggerCategory with rawValue '\(rawValue)' already exists.")
            }
        }
    }

    /// Convenience initializer that accepts a string value directly.
    ///
    /// - Parameter value: The string value of the category.
    public init(_ value: String) {
        self.init(rawValue: value)
    }
}
