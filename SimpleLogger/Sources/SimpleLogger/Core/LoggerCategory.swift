//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A protocol defining the requirements for logger category types.
///
/// Conforming types must be string-backed, hashable, equatable, and safe to use across
/// concurrency domains.
internal protocol LoggerCategoryRepresentable: RawRepresentable, Hashable, Equatable, Sendable
where RawValue == String {}

/// An actor responsible for tracking registered logger categories.
///
/// This ensures category uniqueness across concurrent initialisation and provides a central
/// registry for duplicate detection.
private actor CategoryRegistry {

    /// The shared global category registry.
    internal static let shared = CategoryRegistry()

    /// A set of registered category identifiers.
    ///
    /// Values are stored in lowercased form to ensure case-insensitive matching.
    private var registry: Set<String> = []

    /// Inserts a category into the registry if it does not already exist.
    ///
    /// - Parameter rawValue: The category identifier to register.
    /// - Returns: `true` if the category was newly inserted, or `false` if it already existed.
    internal func insertIfNew(_ rawValue: String) -> Bool {
        let key = rawValue.lowercased()
        if registry.contains(key) {
            return false
        }
        registry.insert(key)
        return true
    }
}

/// A strongly typed logger category.
///
/// `LoggerCategory` provides a safer and more structured alternative to raw string-based logger
/// categories, with built-in duplicate detection.
public struct LoggerCategory: LoggerCategoryRepresentable {

    /// The underlying string value of the category.
    public let rawValue: String

    /// An internal category used for logging package-level warnings.
    private static let internalCategory = "SimpleLoggerPackage"

    /// Creates a logger category from a raw string value.
    ///
    /// If a duplicate category is detected at runtime, a warning is logged using the internal
    /// package logger.
    ///
    /// - Parameter rawValue: The string identifier for the category.
    public init(rawValue: String) {
        self.rawValue = rawValue

        Task {
            let isUnique = await CategoryRegistry.shared.insertIfNew(rawValue)
            if !isUnique {
                Logger(subsystem: subsystem, category: Self.internalCategory)
                    .warning("Duplicate LoggerCategory '\(rawValue, privacy: .public)' detected.")
            }
        }
    }

    /// Creates a logger category from a string value.
    ///
    /// This is a convenience initializer equivalent to `init(rawValue:)`.
    ///
    /// - Parameter value: The string identifier for the category.
    public init(_ value: String) {
        self.init(rawValue: value)
    }
}
