//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Defines a type that represents a log category.
///
/// Implement this protocol to ensure that all logging categories can be
/// represented as a string value, facilitating standardized logging across
/// different parts of an application.
public protocol LogCategoryRepresentable {

    /// A string representation of the logging category.
    ///
    /// This value is used to categorize logs, helping with the organization and
    /// filtering of log output in logging systems or tools.
    var value: String { get }
}
