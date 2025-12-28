//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A namespace responsible for exporting log entries into various data formats.
internal enum LoggerExporter {

    /// Exports the provided log entries using the specified format.
    ///
    /// The logs are sorted by date in ascending order before export. The export work is performed
    /// asynchronously on a background thread to avoid blocking the caller. Depending on the chosen
    /// format, the logs may be encoded as JSON, JSON Lines, CSV, plain text, or compressed
    /// using gzip.
    ///
    /// - Parameters:
    ///   - logs: The log entries to export.
    ///   - format: The export format to use.
    /// - Returns: A `Data` value containing the exported logs.
    /// - Throws: An error if encoding or compression fails.
    internal static func export(
        logs: [LoggerRepresentation],
        as format: Export.Format
    ) async throws -> Data {

        try await Task {
            let logs = logs.sorted { $0.date < $1.date }

            switch format {
                case .json:
                    return try exportJSON(logs)

                case .jsonLines:
                    return try exportJSONLines(logs)

                case .csv(let delimiter):
                    return try exportCSV(logs, delimiter: delimiter)

                case .log:
                    return exportPlainText(logs)

                case .gzip(let type):
                    return try await export(logs: logs, as: type).gzipped()
            }
        }.value
    }
}

extension LoggerExporter {

    /// Exports log entries as a single JSON document.
    ///
    /// The output is pretty-printed, sorted by keys, and uses ISO 8601 date encoding.
    ///
    /// - Parameter logs: The log entries to encode.
    /// - Returns: A `Data` value containing the JSON representation.
    /// - Throws: An error if JSON encoding fails.
    private static func exportJSON(_ logs: [LoggerRepresentation]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(logs)
    }
}

extension LoggerExporter {

    /// Exports log entries using the JSON Lines format.
    ///
    /// Each log entry is encoded as a single JSON object on its own line. Dates are encoded
    /// using the ISO 8601 format.
    ///
    /// - Parameter logs: The log entries to encode.
    /// - Returns: A `Data` value containing the JSON Lines output.
    /// - Throws: An error if encoding any log entry fails.
    private static func exportJSONLines(_ logs: [LoggerRepresentation]) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let lines = try logs.map { log in
            let data = try encoder.encode(log)
            return String(decoding: data, as: UTF8.self)
        }

        let output = lines.joined(separator: "\n")
        return Data(output.utf8)
    }
}

extension LoggerExporter {

    /// Exports log entries in CSV format.
    ///
    /// The first row contains column headers. All values are escaped and quoted to ensure
    /// compatibility with standard CSV parsers.
    ///
    /// - Parameters:
    ///   - logs: The log entries to export.
    ///   - delimiter: The delimiter used to separate columns.
    /// - Returns: A `Data` value containing the CSV output.
    /// - Throws: An error if export fails.
    private static func exportCSV(
        _ logs: [LoggerRepresentation],
        delimiter: Export.Delimiter
    ) throws -> Data {

        var lines: [String] = []

        // Header
        lines.append([
            "date",
            "level",
            "subsystem",
            "category",
            "message"
        ].joined(separator: delimiter.rawValue))

        // Rows
        for log in logs {
            lines.append([
                escape(log.date.ISO8601Format()),
                escape(log.level.description),
                escape(log.subsystem),
                escape(log.category),
                escape(log.message)
            ].joined(separator: delimiter.rawValue))
        }

        let csv = lines.joined(separator: "\n")
        return Data(csv.utf8)
    }

    /// Escapes a string value for inclusion in a CSV field.
    ///
    /// Double quotes are escaped according to CSV rules and the entire value is wrapped in
    /// quotes.
    ///
    /// - Parameter value: The raw string value.
    /// - Returns: A CSV-safe, escaped string.
    private static func escape(_ value: String) -> String {
        let escaped = value
            .replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
}

extension LoggerExporter {

    /// Exports log entries as plain text.
    ///
    /// Each log entry is rendered on its own line using a fixed, human-readable format that
    /// includes the date, log level, category, and message.
    ///
    /// - Parameter logs: The log entries to export.
    /// - Returns: A `Data` value containing the plain-text output.
    private static func exportPlainText(
        _ logs: [LoggerRepresentation]
    ) -> Data {

        let lines = logs.map { log in
            "[\(log.date.ISO8601Format())] " +
            "[\(log.level.description)] " +
            "[\(log.category)] " +
            log.message
        }

        return Data(lines.joined(separator: "\n").utf8)
    }
}
