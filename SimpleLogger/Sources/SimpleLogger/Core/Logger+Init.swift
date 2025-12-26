//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

@_exported import OSLog

/// A typealias providing a simplified public name for `OSLog.Logger`.
///
/// This allows consumers of the module to use `SimpleLogger` instead of referring directly to
/// `Logger`.
public typealias SimpleLogger = Logger

/// The logging subsystem used by all `SimpleLogger` instances.
///
/// This value resolves to the app or package bundle identifier when available. If the bundle
/// identifier cannot be determined, a default fallback identifier is used instead.
internal let subsystem: String = {
    Bundle.main.bundleIdentifier
    ?? "com.markbattistella.package.SimpleLogger"
}()

extension SimpleLogger {

    /// Creates a logger using a strongly typed logger category.
    ///
    /// - Parameter category: A `LoggerCategory` used to scope log messages.
    public init(category: LoggerCategory) {
        self.init(subsystem: subsystem, category: category.rawValue)
    }
}

