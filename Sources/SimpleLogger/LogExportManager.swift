//
// Project:
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import OSLog

// MARK: - Main variables

public final class LogExportManager: ObservableObject {

    @Published
    public var excludeSystemLogs: Bool

    @Published
    public var filterType: FilterType

    @Published
    public var specificDate: Date

    @Published
    public var dateRangeStart: Date

    @Published
    public var dateRangeFinish: Date

    @Published
    public var hourRangeStart: Date

    @Published
    public var hourRangeFinish: Date

    @Published
    public var selectedPreset: Preset

    @Published
    public var exportState: ExportState

    @Published
    public var logs: [OSLogEntryLog] = []

    public init(
        excludeSystemLogs: Bool = true,
        filterType: FilterType = .specificDate,
        specificDate: Date = .now,
        dateRangeStart: Date = Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now,
        dateRangeFinish: Date = .now,
        hourRangeStart: Date = LogExportManager.setTime(hour: 8, minute: 0) ?? .now,
        hourRangeFinish: Date = LogExportManager.setTime(hour: 17, minute: 0) ?? .now,
        selectedPreset: Preset = .minutesFive,
        exportState: ExportState = .ready
    ) {
        self.excludeSystemLogs = excludeSystemLogs
        self.filterType = filterType
        self.specificDate = specificDate
        self.dateRangeStart = dateRangeStart
        self.dateRangeFinish = dateRangeFinish
        self.hourRangeStart = hourRangeStart
        self.hourRangeFinish = hourRangeFinish
        self.selectedPreset = selectedPreset
        self.exportState = exportState
    }
}

// MARK: - Enums

extension LogExportManager {

    public enum ExportState {
        case ready, processing, completed, failed
    }

    public var isExporting: Bool {
        exportState == .processing
    }

    public enum FilterType: CustomStringConvertible, CaseIterable {
        case specificDate
        case dateRange
        case hourRange
        case preset

        public var description: String {
            switch self {
                case .specificDate: "Specific date"
                case .dateRange: "Date range"
                case .hourRange: "Time range"
                case .preset: "Preset options"
            }
        }
    }

    public enum Preset: CustomStringConvertible, CaseIterable {
        case minutesFive
        case minutesTen
        case minutesFifteen
        case minutesThirty
        case hoursOne
        case hoursSix
        case hoursTwelve
        case hoursTwentyFour

        public var description: String {
            switch self {
                case .minutesFive: "5 minutes"
                case .minutesTen: "10 minutes"
                case .minutesFifteen: "15 minutes"
                case .minutesThirty: "30 minutes"
                case .hoursOne: "1 hour"
                case .hoursSix: "6 hours"
                case .hoursTwelve: "12 hours"
                case .hoursTwentyFour: "24 hours"
            }
        }

        internal var presetDate: Date {
            switch self {
                case .minutesFive: Date.now.addingTimeInterval(-.minutesFive)
                case .minutesTen: Date.now.addingTimeInterval(-.minutesTen)
                case .minutesFifteen: Date.now.addingTimeInterval(-.minutesFifteen)
                case .minutesThirty: Date.now.addingTimeInterval(-.minutesThirty)
                case .hoursOne: Date.now.addingTimeInterval(-.hoursOne)
                case .hoursSix: Date.now.addingTimeInterval(-.hoursSix)
                case .hoursTwelve: Date.now.addingTimeInterval(-.hoursTwelve)
                case .hoursTwentyFour:  Date.now.addingTimeInterval(-.hoursTwentyFour)
            }
        }
    }
}

// MARK: - Public methods

extension LogExportManager {

    public func copyToClipboardAction() {
        self.gatherLogs()
    }

    public func exportLogFileAction() {}
    public func shareLogFileAction() {}
}

// MARK: - Helper methods

extension LogExportManager {

    public static func setTime(hour: Int, minute: Int) -> Date? {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: startOfDay)
    }
}

// MARK: - Internal methods

extension LogExportManager {

    internal func gatherLogs() {
        self.exportState = .processing
        let logPredicate: NSPredicate? = getLogPredicate()
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let entries = try store
                .getEntries(matching: logPredicate)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { log in
                    if excludeSystemLogs {
                        return log.subsystem == Bundle.main.bundleIdentifier!
                    }
                    return true
                }
            self.exportState = .completed
            self.logs = entries
        } catch {
            self.exportState = .failed
            self.logs = []
        }
    }

    private func getLogPredicate() -> NSPredicate? {
        switch filterType {
            case .specificDate:
                guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: specificDate) else {
                    return nil
                }
                return NSPredicate(
                    format: "date >= %@ AND date < %@",
                    specificDate as NSDate,
                    nextDay as NSDate
                )

            case .dateRange:
                return NSPredicate(
                    format: "date >= %@ AND date <= %@",
                    dateRangeStart as NSDate,
                    dateRangeFinish as NSDate
                )

            case .hourRange:
                guard let (startDate, endDate) = getHourRangeDates() else {
                    return nil
                }
                return NSPredicate(
                    format: "date >= %@ AND date <= %@",
                    startDate as NSDate,
                    endDate as NSDate
                )

            case .preset:
                let startDate = selectedPreset.presetDate
                return NSPredicate(format: "date >= %@", startDate as NSDate)
        }
    }

    private func createDateTime(hour: Int, minute: Int, from date: Date) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)
    }

    private func getHourRangeDates() -> (startDate: Date, endDate: Date)? {
        let startHour = Calendar.current.component(.hour, from: hourRangeStart)
        let startMinute = Calendar.current.component(.minute, from: hourRangeStart)
        let finishHour = Calendar.current.component(.hour, from: hourRangeFinish)
        let finishMinute = Calendar.current.component(.minute, from: hourRangeFinish)

        guard let startDate = createDateTime(hour: startHour, minute: startMinute, from: specificDate),
              let endDate = createDateTime(hour: finishHour, minute: finishMinute, from: specificDate)
        else {
            return nil
        }
        return (startDate, endDate)
    }
}
