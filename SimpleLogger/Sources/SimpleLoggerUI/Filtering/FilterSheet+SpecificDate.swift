//
// Project: SimpleLoggerUI
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLogger

extension LogListScreen.FilterSheet {
    
    /// A view that allows the user to filter logs by a single, specific date.
    ///
    /// `SpecificDate` presents a date picker that limits log results to entries recorded within
    /// the selected calendar day.
    internal struct SpecificDate: View {
        
        /// The shared logger manager that stores the selected date.
        @Environment(LoggerManager.self)
        private var logManager
        
        var body: some View {
            DatePicker(
                "Specific date",
                selection: Bindable(logManager).specificDate,
                in: ...Date.now,
                displayedComponents: .date
            )
        }
    }
}
