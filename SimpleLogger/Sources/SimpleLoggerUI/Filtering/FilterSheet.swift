//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

#Preview {
    LogListScreen.FilterSheet()
        .environment(LoggerManager())
}

extension LogListScreen {
    
    /// A modal sheet that allows the user to filter visible log entries.
    ///
    /// `FilterSheet` provides controls for excluding system logs, selecting a filter strategy,
    /// configuring filter parameters, and choosing which log levels should be included.
    internal struct FilterSheet: View {
        
        /// The shared logger manager that stores and applies filter state.
        @Environment(LoggerManager.self)
        private var logManager
        
        /// Dismiss action for closing the sheet.
        @Environment(\.dismiss)
        private var dismiss
        
        var body: some View {
            NavigationStack {
                Form {
                    Section {
                        Toggle(
                            "Exclude system logs",
                            isOn: Bindable(logManager).excludeSystemLogs
                        )
                    }
                    
                    Section {
                        Picker("Filter by", selection: Bindable(logManager).kind) {
                            ForEach(Filter.Kind.allCases) { type in
                                Text(type.description).tag(type)
                            }
                        }
                        
                        switch logManager.kind {
                            case .specificDate:
                                SpecificDate()
                            case .dateRange:
                                DateRange()
                            case .hourRange:
                                HourRange()
                            case .preset:
                                Preset()
                        }
                    } footer: {
                        Footer(kind: logManager.kind)
                    }
                    
                    Section {
                        NavigationLink {
                            LogLevelPicker()
                        } label: {
                            LabeledContent(
                                "Log levels",
                                value: "\(logManager.levels.count) selected"
                            )
                        }
                    }
                }
                .navigationTitle("Filter options")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", systemImage: "checkmark") {
                            dismiss()
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
            .presentationDetents([.fraction(0.7), .large])
            .interactiveDismissDisabled()
            
            .alert(item: Bindable(logManager).lastError) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK")) {
                        logManager.lastError = nil
                    }
                )
            }
        }
    }
}

extension LogListScreen.FilterSheet {
    
    /// Contextual help text describing the currently selected filter strategy.
    ///
    /// The footer updates dynamically as the filter kind changes to explain how each option
    /// affects the displayed log entries.
    internal struct Footer: View {
        
        /// The active filter kind being described.
        let kind: Filter.Kind
        
        var body: some View {
            switch kind {
                case .specificDate:
                    Text("Select a single date to view logs recorded on that day. All logs between 00:00 and 24:00 are included.")
                    
                case .dateRange:
                    Text("Choose a start and end date to view logs across multiple days. Logs from both boundary dates are included.")
                    
                case .hourRange:
                    Text("Select a date and an hour range to narrow logs to a specific time window on that day. Note: 24:00 represents the start of the next day.")
                    
                case .preset:
                    Text("Select a preset to quickly apply a commonly used time range without manual configuration.")
            }
        }
    }
}
