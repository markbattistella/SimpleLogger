//
// Project: SimpleLogger
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - System and OS

extension LoggerCategory {

    /// Logger category for lifecycle-related logs.
    public static let lifecycle = LoggerCategory("Lifecycle")

    /// Logger category for initialization-related logs.
    public static let initialization = LoggerCategory("Initialization")

    /// Logger category for deinitialization-related logs.
    public static let deinitialization = LoggerCategory("Deinitialization")

    /// Logger category for file system-related logs.
    public static let fileSystem = LoggerCategory("FileSystem")

    /// Logger category for background tasks-related logs.
    public static let backgroundTasks = LoggerCategory("BackgroundTasks")

    /// Logger category for scheduling-related logs.
    public static let scheduling = LoggerCategory("Scheduling")

    /// Logger category for notifications-related logs.
    public static let notifications = LoggerCategory("Notifications")

    /// Logger category for timers-related logs.
    public static let timers = LoggerCategory("Timers")

    /// Logger category for push notifications-related logs.
    public static let pushNotifications = LoggerCategory("PushNotifications")

    /// Logger category for job queue-related logs.
    public static let jobs = LoggerCategory("Jobs")

    /// Logger category for work queue-related logs.
    public static let workQueue = LoggerCategory("WorkQueue")
}
