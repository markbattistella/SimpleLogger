//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

extension LogListScreen.FilterSheet {
    
    /// A view that allows the user to apply a predefined time-based filter.
    ///
    /// `Preset` presents grouped preset options that represent commonly used log filtering
    /// ranges, enabling quick selection without manual date or time configuration.
    internal struct Preset: View {
        
        /// The shared logger manager that stores the selected preset.
        @Environment(LoggerManager.self)
        private var logManager
        
        var body: some View {
            Picker("Preset option", selection: Bindable(logManager).preset) {
                ForEach(Filter.Preset.groups) { group in
                    Section(group.title) {
                        ForEach(group.presets) { preset in
                            Text(preset.description).tag(preset)
                        }
                    }
                }
            }
        }
    }
}
