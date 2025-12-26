//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Architecture and Patterns

extension LoggerCategory {
    
    /// Logger category for routing-related logs.
    public static let routing = LoggerCategory("Routing")
    
    /// Logger category for navigation-related logs.
    public static let navigation = LoggerCategory("Navigation")
    
    /// Logger category for state management-related logs.
    public static let stateManagement = LoggerCategory("StateManagement")
    
    /// Logger category for dependency injection-related logs.
    public static let dependencyInjection = LoggerCategory("DependencyInjection")
    
    /// Logger category for observer-related logs.
    public static let observers = LoggerCategory("Observers")
    
    /// Logger category for publisher-related logs.
    public static let publishers = LoggerCategory("Publishers")
    
    /// Logger category for subscriber-related logs.
    public static let subscribers = LoggerCategory("Subscribers")
    
    /// Logger category for event-related logs.
    public static let events = LoggerCategory("Events")
    
    /// Logger category for signal-related logs.
    public static let signals = LoggerCategory("Signals")
}
