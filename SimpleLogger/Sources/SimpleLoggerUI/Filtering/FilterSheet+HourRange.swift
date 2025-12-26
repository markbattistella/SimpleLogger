//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

extension LogListScreen.FilterSheet {

    /// A view that allows the user to filter logs by a specific date and hour range.
    ///
    /// `HourRange` combines a date picker with start and end hour steppers to define a precise
    /// time window within a single day. Hour values are constrained to ensure a valid,
    /// non-empty range.
    internal struct HourRange: View {

        /// The shared logger manager that stores the active hour range filter.
        @Environment(LoggerManager.self)
        private var logManager

        var body: some View {
            DatePicker(
                "Date",
                selection: Bindable(logManager).hourRangeDate,
                in: ...Date.now,
                displayedComponents: .date
            )

            Stepper(
                value: Bindable(logManager).hourRangeStartHour,
                in: 0...max(0, logManager.hourRangeEndHour - 1)
            ) {
                LabeledContent(
                    "From",
                    value: logManager.hourRangeStartHour == 24 ?
                    "24:00" : "\(logManager.hourRangeStartHour):00"
                ).monospacedDigit()
            }

            Stepper(
                value: Bindable(logManager).hourRangeEndHour,
                in: (logManager.hourRangeStartHour + 1)...24
            ) {
                LabeledContent(
                    "To",
                    value: logManager.hourRangeEndHour == 24 ?
                    "24:00" : "\(logManager.hourRangeEndHour):00"
                ).monospacedDigit()
            }
        }
    }
}
