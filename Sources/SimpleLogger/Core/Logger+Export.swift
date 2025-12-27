//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import UniformTypeIdentifiers

extension UTType {

    /// A custom uniform type identifier for JSON Lines (`.jsonl`) files.
    ///
    /// This type conforms to `.json` and is exported under a package-specific identifier.
    internal static let jsonLines = UTType(
        exportedAs: "\(subsystem).jsonl",
        conformingTo: .json
    )
}

/// A namespace for export-related types.
///
/// `Export` groups together enums that describe supported export kinds, formats, and
/// configuration options.
public enum Export {}

extension Export {

    /// The high-level kind of export available to the user.
    ///
    /// This enum is primarily intended for UI selection and presentation.
    public enum Kind: Int, CaseIterable, Identifiable {

        /// Export as a plain log file.
        case log

        /// Export as a JSON file.
        case json

        /// Export as a JSON Lines file.
        case jsonLines

        /// Export as a CSV file.
        case csv

        /// A stable identifier for SwiftUI collections.
        public var id: Int { rawValue }

        /// A human-readable description of the export kind.
        public var description: String {
            switch self {
                case .log: "Log"
                case .json: "JSON"
                case .jsonLines: "JSON Lines"
                case .csv: "CSV"
            }
        }
    }
}

extension Export {

    /// A concrete export format, including optional wrapping formats.
    ///
    /// `Format` supports both base formats and recursively wrapped formats such as
    /// gzip-compressed exports.
    public enum Format: Hashable, Sendable {

        /// A plain log text format.
        case log

        /// A JSON document format.
        case json

        /// A JSON Lines format.
        case jsonLines

        /// A CSV format with a configurable delimiter.
        case csv(Delimiter)

        /// A gzip-compressed wrapper around another export format.
        indirect case gzip(Format)

        /// The uniform type identifier associated with the export format.
        public var utType: UTType {
            switch self {
                case .log:
                        .plainText
                case .json:
                        .json
                case .jsonLines:
                        .jsonLines
                case .csv:
                        .commaSeparatedText
                case .gzip:
                        .gzip
            }
        }

        /// The filename suffix associated with the export format.
        ///
        /// For wrapped formats, the suffix is composed recursively.
        public var filenameSuffix: String {
            switch self {
                case .log:
                    "log"
                case .json:
                    "json"
                case .jsonLines:
                    "jsonl"
                case .csv:
                    "csv"
                case .gzip(let wrapped):
                    wrapped.filenameSuffix + ".gz"
            }
        }
    }

    /// A delimiter used when exporting CSV files.
    public enum Delimiter: String, CaseIterable, Sendable {

        /// A comma character (`,`).
        case comma = ","

        /// A semicolon character (`;`).
        case semicolon = ";"

        /// A tab character.
        case tab = "\t"

        /// A pipe character (`|`).
        case pipe = "|"

        /// A human-readable label describing the delimiter.
        public var label: String {
            switch self {
                case .comma:
                    "Comma"
                case .semicolon:
                    "Semicolon"
                case .tab:
                    "Tab"
                case .pipe:
                    "Pipe"
            }
        }
    }
}
