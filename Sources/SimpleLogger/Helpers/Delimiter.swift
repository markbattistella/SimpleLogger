//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// An enumeration representing various delimiters that can be used in CSV formatting.
///
/// The `Delimiter` enum provides different options for delimiters commonly used in CSV data.
/// It also includes a method to safely escape the delimiter within CSV fields to ensure
/// data integrity when generating CSV files.
public enum Delimiter: String {

    /// Comma delimiter, commonly used in CSV files.
    case comma = ","

    /// Semicolon delimiter, often used in locales where commas are used as decimal separators.
    case semicolon = ";"

    /// Tab delimiter, often used for tab-separated values (TSV) files.
    case tab = "\t"

    /// Pipe delimiter, used as an alternative to commas or semicolons in CSV files.
    case pipe = "|"

    /// Escapes occurrences of the delimiter in a given string by prefixing them with a backslash.
    ///
    /// This method ensures that the delimiter character within the data is escaped, preventing it
    /// from being misinterpreted as a field separator in the CSV output.
    ///
    /// - Parameter value: The string in which to escape occurrences of the delimiter.
    /// - Returns: A new string with all occurrences of the delimiter character escaped.
    internal func escape(_ value: String) -> String {
        switch self {
            case .comma:
                return value.replacingOccurrences(of: self.rawValue, with: "\\\(self.rawValue)")
            case .semicolon:
                return value.replacingOccurrences(of: self.rawValue, with: "\\\(self.rawValue)")
            case .tab:
                return value.replacingOccurrences(of: self.rawValue, with: "\\\(self.rawValue)")
            case .pipe:
                return value.replacingOccurrences(of: self.rawValue, with: "\\\(self.rawValue)")
        }
    }
}
