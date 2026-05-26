//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import Testing

@testable import SimpleLogger

@MainActor
@Suite("LoggerManager")
struct LoggerManagerTests {

  @Test("Invalid scope resets fetching state without an error")
  func invalidScopeResetsFetchingStateWithoutAnError() async {
    let manager = LoggerManager()
    manager.kind = .dateRange
    manager.dateRangeStart = Date(timeIntervalSince1970: 2)
    manager.dateRangeEnd = Date(timeIntervalSince1970: 1)

    await manager.fetch()

    #expect(!manager.isFetching)
    #expect(!manager.hasValidResults)
    #expect(manager.lastError == nil)
  }
}
