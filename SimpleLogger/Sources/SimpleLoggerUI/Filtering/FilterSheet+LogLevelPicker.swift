//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

#Preview {
    NavigationStack {
        LogListScreen.FilterSheet.LogLevelPicker()
    }
    .environment(LoggerManager())
}

extension LogListScreen.FilterSheet {

    /// A view that allows the user to select which log levels are included in the active filter.
    ///
    /// `LogLevelPicker` presents all available log levels in a multi-selection list and provides
    /// a convenience action to quickly select or deselect all levels.
    internal struct LogLevelPicker: View {

        /// The shared logger manager that stores the selected log levels.
        @Environment(LoggerManager.self)
        private var logManager

        var body: some View {
            List(selection: Bindable(logManager).levels) {
                Section {
                    ForEach(LogLevel.allCases) { level in
                        Text(level.description)
                            .tag(level)
                            .id(level)
                    }
                }

                Section {
                    Button(logManager.levels.isEmpty ? "Select all levels" : "Deselect all levels") {
                        logManager.levels = logManager.levels.isEmpty
                            ? Set(LogLevel.allCases) : []
                    }
                } footer: {
                    Text("When all the levels are unselected, no logs will be shown.")
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle("Filter Log Levels")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
