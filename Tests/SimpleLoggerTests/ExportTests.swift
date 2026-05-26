//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import Testing

@testable import SimpleLogger

@Suite("Export")
struct ExportTests {

  @Test("Plain text export sorts logs by date")
  func plainTextExportSortsLogsByDate() async throws {
    let earlier = makeLog(id: 2, timestamp: 10, message: "earlier")
    let later = makeLog(id: 1, timestamp: 20, message: "later")

    let data = try await LoggerExporter.export(logs: [later, earlier], as: .log)
    let output = String(decoding: data, as: UTF8.self)
    let earlierIndex = try #require(output.range(of: "earlier")?.lowerBound)
    let laterIndex = try #require(output.range(of: "later")?.lowerBound)

    #expect(earlierIndex < laterIndex)
  }

  @Test("JSON Lines export writes one JSON object per log")
  func jsonLinesExportWritesOneObjectPerLog() async throws {
    let logs = [
      makeLog(id: 1, timestamp: 10, message: "first"),
      makeLog(id: 2, timestamp: 20, message: "second"),
    ]

    let data = try await LoggerExporter.export(logs: logs, as: .jsonLines)
    let lines = String(decoding: data, as: UTF8.self).split(separator: "\n")

    #expect(lines.count == 2)
    #expect(lines.allSatisfy { $0.contains(#""message""#) })
  }

  @Test("CSV export quotes and escapes field values")
  func csvExportQuotesAndEscapesFieldValues() async throws {
    let log = makeLog(message: #"value with, comma and "quotes""#)

    let data = try await LoggerExporter.export(logs: [log], as: .csv(.comma))
    let output = String(decoding: data, as: UTF8.self)

    #expect(output.contains("date,level,subsystem,category,message"))
    #expect(output.contains(#""value with, comma and ""quotes""""#))
  }

  @Test("Gzip export produces gzip payload")
  func gzipExportProducesGzipPayload() async throws {
    let data = try await LoggerExporter.export(logs: [makeLog()], as: .gzip(.json))
    let bytes = [UInt8](data.prefix(2))

    #expect(bytes == [0x1f, 0x8b])
  }

  @Test("Export formats expose expected filename suffixes")
  func exportFormatsExposeExpectedFilenameSuffixes() {
    #expect(Export.Format.log.filenameSuffix == "log")
    #expect(Export.Format.json.filenameSuffix == "json")
    #expect(Export.Format.jsonLines.filenameSuffix == "jsonl")
    #expect(Export.Format.csv(.semicolon).filenameSuffix == "csv")
    #expect(Export.Format.gzip(.jsonLines).filenameSuffix == "jsonl.gz")
  }

  private func makeLog(
    id: UInt64 = 1,
    timestamp: TimeInterval = 10,
    level: LogLevel = .info,
    subsystem: String = "com.example.app",
    category: String = "Tests",
    message: String = "message"
  ) -> LoggerRepresentation {
    LoggerRepresentation(
      id: id,
      date: Date(timeIntervalSince1970: timestamp),
      level: level,
      subsystem: subsystem,
      category: category,
      message: message
    )
  }
}
