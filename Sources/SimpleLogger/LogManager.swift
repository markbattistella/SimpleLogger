//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import OSLog
import PlatformChecker

/// A manager class responsible for handling logging throughout an application.
///
/// This class utilizes the Singleton pattern to provide a shared instance that
/// manages logging operations based on the environment settings—either `production`
/// or `development`.
public final class LogManager {

    /// The singleton instance of `LogManager`.
    public static let shared = LogManager()

    /// Initializes a new instance of the `LogManager`.
    private init() {}

    /// The subsystem identifier derived from the application's bundle identifier.
    private let subsystem = Bundle.main.bundleIdentifier.unsafelyUnwrapped

    /// Defines the environment contexts in which logging can be performed.
    public enum Environment {

        /// Indicates the production environment where logging is always enabled.
        case production

        /// Indicates the development environment where logging is conditional
        /// based on certain runtime checks.
        case development
    }

    /// Determines whether logs should be recorded based on the specified environment.
    ///
    /// - Parameter environment: The environment (`production` or `development`) to consider 
    /// when determining log eligibility.
    /// - Returns: `true` if logging should occur under the specified environment, otherwise `false`.
    private func shouldLog(environment: Environment) -> Bool {
        switch environment {
            case .development:
                return Platform.isDebugMode || Platform.isSimulator || Platform.isTestFlight
            case .production:
                return true
        }
    }

    /// Retrieves a logger configured for the specified environment and category.
    ///
    /// This method checks the environment and returns an appropriate logger.
    /// In cases where logging should not occur based on the environment,
    /// a no-op logger is returned with a subsystem and category of "Noop".
    ///
    /// - Parameters:
    ///   - environment: The environment in which the logger will be used 
    ///   (default is `.production`).
    ///   - category: The category for the logs, conforming to `LogCategoryRepresentable`.
    /// - Returns: A `Logger` instance ready to be used for logging in the given category 
    /// and environment.
    public func getLogger(
        environment: Environment = .production,
        category: LogCategoryRepresentable
    ) -> Logger {
        guard shouldLog(environment: environment) else {
            return Logger(subsystem: "Noop", category: "Noop")
        }
        return Logger(subsystem: subsystem, category: category.value)
    }
}
