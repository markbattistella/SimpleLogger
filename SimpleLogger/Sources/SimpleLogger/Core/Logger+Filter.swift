//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import SwiftUI

/// A namespace for log filtering types.
///
/// `Filter` groups together filter-related enums and logic without
/// introducing a concrete type.
public enum Filter {}

extension Filter {

    /// The high-level kind of filter being applied.
    ///
    /// This enum is primarily used for UI selection and presentation.
    public enum Kind: Int, CaseIterable, Identifiable {

        /// Filter logs matching a single calendar date.
        case specificDate

        /// Filter logs within a start and end date range.
        case dateRange

        /// Filter logs within a specific time-of-day range.
        case hourRange

        /// Filter logs using a predefined relative time preset.
        case preset

        /// A stable identifier for SwiftUI collections.
        public var id: Int { rawValue }

        /// A human-readable description of the filter kind.
        public var description: String {
            switch self {
            case .specificDate:
                "Specific Date"
            case .dateRange:
                "Date Range"
            case .hourRange:
                "Hour Range"
            case .preset:
                "Preset Option"
            }
        }
    }
}

extension Filter {

    /// A concrete filter scope with associated values.
    ///
    /// `Scope` encapsulates the parameters required to compute an effective
    /// date window for filtering log entries.
    internal enum Scope {

        /// A filter targeting a single calendar date.
        case specificDate(Date)

        /// A filter spanning an inclusive start and end date.
        case dateRange(from: Date, to: Date)

        /// A filter spanning a specific start and end time.
        case hourRange(from: Date, to: Date)

        /// A filter based on a relative time preset.
        case preset(Preset)

        /// Resolves the scope into a concrete date window.
        ///
        /// - Parameter calendar: The calendar used for date calculations.
        ///   Defaults to the current calendar.
        /// - Returns: A tuple containing the start date and an optional end
        ///   date, or `nil` if the scope cannot be resolved.
        func dateWindow(
            using calendar: Calendar = .current
        ) -> (start: Date, end: Date?)? {

            switch self {

            case .specificDate(let date):
                let start = calendar.startOfDay(for: date)
                let end = calendar.date(byAdding: .day, value: 1, to: start)
                return (start, end)

            case .dateRange(let from, let to):
                let start = calendar.startOfDay(for: from)
                let end = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: calendar.startOfDay(for: to)
                )
                return end.map { (start, $0) }

            case .hourRange(let from, let to):
                return (from, to)

            case .preset(let preset):
                let end = Date()
                let start = end.addingTimeInterval(
                    -preset.timeInterval.asTimeInterval
                )
                return (start, end)
            }
        }
    }
}

extension Filter {

    /// A predefined relative time filter option.
    ///
    /// Presets represent commonly used rolling time windows for filtering
    /// recent log entries.
    public enum Preset: Int, CaseIterable, Identifiable {

        case lastFiveMinutes, lastTenMinutes, lastFifteenMinutes, lastThirtyMinutes
        case lastOneHour, lastSixHours, lastTwelveHours, lastTwentyFourHours
        case lastThreeDays, lastSevenDays, lastFourteenDays, lastThirtyDays
        case lastNinetyDays, lastOneYear

        /// A stable identifier for SwiftUI collections.
        public var id: Int { rawValue }

        /// A human-readable description of the preset.
        public var description: String {
            switch self {
            case .lastFiveMinutes:
                "5 minutes"
            case .lastTenMinutes:
                "10 minutes"
            case .lastFifteenMinutes:
                "15 minutes"
            case .lastThirtyMinutes:
                "30 minutes"
            case .lastOneHour:
                "1 hour"
            case .lastSixHours:
                "6 hours"
            case .lastTwelveHours:
                "12 hours"
            case .lastTwentyFourHours:
                "24 hours"
            case .lastThreeDays:
                "3 days"
            case .lastSevenDays:
                "7 days"
            case .lastFourteenDays:
                "14 days"
            case .lastThirtyDays:
                "30 days"
            case .lastNinetyDays:
                "90 days"
            case .lastOneYear:
                "1 year"
            }
        }
    }
}

extension Filter.Preset {

    /// A grouping of related preset filters for presentation.
    public struct Group: Identifiable {

        /// The unique identifier for the group.
        public let id: Int

        /// The display title of the group.
        public let title: String

        /// The presets contained in the group.
        public let presets: [Filter.Preset]

        /// Creates a new preset group.
        ///
        /// - Parameters:
        ///   - id: The unique identifier for the group.
        ///   - title: The display title of the group.
        ///   - presets: The presets included in the group.
        public init(id: Int, title: String, presets: [Filter.Preset]) {
            self.id = id
            self.title = title
            self.presets = presets
        }
    }

    /// Predefined groups of presets for UI presentation.
    @MainActor
    public static let groups: [Group] = [
        Group(
            id: 0,
            title: String(localized: "Minutes"),
            presets: [
                .lastFiveMinutes,
                .lastTenMinutes,
                .lastFifteenMinutes,
                .lastThirtyMinutes
            ]
        ),
        Group(
            id: 1,
            title: String(localized: "Hours"),
            presets: [
                .lastOneHour,
                .lastSixHours,
                .lastTwelveHours,
                .lastTwentyFourHours
            ]
        ),
        Group(
            id: 2,
            title: String(localized: "Days"),
            presets: [
                .lastThreeDays,
                .lastSevenDays,
                .lastFourteenDays,
                .lastThirtyDays,
                .lastNinetyDays
            ]
        ),
        Group(
            id: 3,
            title: String(localized: "Years"),
            presets: [.lastOneYear]
        )
    ]
}

extension Filter.Preset {

    /// The duration represented by the preset.
    ///
    /// This value is used to compute relative date ranges.
    public var timeInterval: Duration {
        switch self {
        case .lastFiveMinutes: .minutes(5)
        case .lastTenMinutes: .minutes(10)
        case .lastFifteenMinutes: .minutes(15)
        case .lastThirtyMinutes: .minutes(30)

        case .lastOneHour: .hours(1)
        case .lastSixHours: .hours(6)
        case .lastTwelveHours: .hours(12)
        case .lastTwentyFourHours: .days(1)

        case .lastThreeDays: .days(3)
        case .lastSevenDays: .weeks(1)
        case .lastFourteenDays: .weeks(2)
        case .lastThirtyDays: .days(30)

        case .lastNinetyDays: .days(90)
        case .lastOneYear: .weeks(52)
        }
    }

    /// The start date implied by the preset, relative to the current time.
    internal var presetDate: Date {
        Date.now.addingTimeInterval(-timeInterval.asTimeInterval)
    }
}
