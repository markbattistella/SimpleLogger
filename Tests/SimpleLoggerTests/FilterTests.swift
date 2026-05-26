//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import Testing

@testable import SimpleLogger

@Suite("Filter")
struct FilterTests {

  @Test("Specific date scope covers the selected calendar day")
  func specificDateScopeCoversSelectedCalendarDay() throws {
    let date = try makeDate(year: 2026, month: 5, day: 26, hour: 14)

    let window = try #require(Filter.Scope.specificDate(date).dateWindow(using: calendar))
    let expectedStart = try makeDate(year: 2026, month: 5, day: 26)
    let expectedEnd = try makeDate(year: 2026, month: 5, day: 27)

    #expect(window.start == expectedStart)
    #expect(window.end == expectedEnd)
  }

  @Test("Date range scope includes the full end day")
  func dateRangeScopeIncludesTheFullEndDay() throws {
    let start = try makeDate(year: 2026, month: 5, day: 1, hour: 11)
    let end = try makeDate(year: 2026, month: 5, day: 3, hour: 9)

    let window = try #require(
      Filter.Scope.dateRange(from: start, to: end).dateWindow(using: calendar)
    )
    let expectedStart = try makeDate(year: 2026, month: 5, day: 1)
    let expectedEnd = try makeDate(year: 2026, month: 5, day: 4)

    #expect(window.start == expectedStart)
    #expect(window.end == expectedEnd)
  }

  @Test("Hour range scope uses exact boundaries")
  func hourRangeScopeUsesExactBoundaries() throws {
    let start = try makeDate(year: 2026, month: 5, day: 26, hour: 9)
    let end = try makeDate(year: 2026, month: 5, day: 26, hour: 17)

    let window = try #require(
      Filter.Scope.hourRange(from: start, to: end).dateWindow(using: calendar)
    )

    #expect(window.start == start)
    #expect(window.end == end)
  }

  @Test("Preset durations match expected rolling windows")
  func presetDurationsMatchExpectedRollingWindows() {
    #expect(Filter.Preset.lastFiveMinutes.timeInterval.asTimeInterval == 300)
    #expect(Filter.Preset.lastOneHour.timeInterval.asTimeInterval == 3_600)
    #expect(Filter.Preset.lastTwentyFourHours.timeInterval.asTimeInterval == 86_400)
    #expect(Filter.Preset.lastOneYear.timeInterval.asTimeInterval == 31_449_600)
  }

  private var calendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar
  }

  private func makeDate(
    year: Int,
    month: Int,
    day: Int,
    hour: Int = 0
  ) throws -> Date {
    let components = DateComponents(
      calendar: calendar,
      timeZone: calendar.timeZone,
      year: year,
      month: month,
      day: day,
      hour: hour
    )

    return try #require(components.date)
  }
}
