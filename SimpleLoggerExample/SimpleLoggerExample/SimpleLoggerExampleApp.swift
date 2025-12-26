//
// Project: SimpleLoggerExample
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI
import SimpleLoggerUI

@main
struct SimpleLoggerExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LogListScreen()
            }
        }
    }
}

#Preview {
    NavigationStack {
        LogListScreen()
    }
    .environment(LoggerManager())
}
