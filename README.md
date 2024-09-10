<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# SimpleLogger

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSimpleLogger%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSimpleLogger%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`SimpleLogger` is a robust and flexible logging framework designed for Swift applications across multiple platforms, including iOS, macOS, tvOS, and watchOS. It provides extensive functionality for managing, filtering, and exporting logs with ease and precision.

## Features

- **Cross-Platform Support:** Unified logging interface across UIKit and AppKit.
- **Flexible Log Management:** Manage log entries with advanced filtering options, including specific dates, date ranges, hour ranges, and preset intervals.
- **Customisable Log Levels:** Extend and customise log levels with additional categories for precise logging.
- **Export Options:** Export logs in plain text, JSON, or CSV formats with configurable delimiters.

## Installation

Add `SimpleLogger` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/SimpleLogger", from: "1.0.0")
]
```

## Usage

### Basic Usage

The simple part of `SimpleLogger` is that there is a convenience initialiser which uses the app's internal BundleIdentifier as the subsystem, and has 89 pre-defined common categories.

Using `SimpleLogger` for general logging is as simple as:

```swift
// Create a logger instance with a specific category
let logger = Logger(category: .ui)

// Log an informational message
logger.info("User tapped the start button")
```

#### Predefined Categories

`SimpleLogger` includes predefined categories to help organise and filter logs more effectively. Below is a table of the available categories:

##### Architecture and Patterns

| Logger Category | Description |
|-----------------------|-------------------------------------------------------|
| `routing` | Logger category for routing-related logs. |
| `navigation` | Logger category for navigation-related logs. |
| `stateManagement` | Logger category for state management-related logs. |
| `dependencyInjection` | Logger category for dependency injection-related logs.|
| `observers` | Logger category for observer-related logs. |
| `publishers` | Logger category for publisher-related logs. |
| `subscribers` | Logger category for subscriber-related logs. |
| `events` | Logger category for event-related logs. |
| `signals` | Logger category for signal-related logs. |

##### Miscellaneous

| Logger Category | Description |
|----------------------------|-------------------------------------------------------|
| `analytics` | Logger category for analytics-related logs. |
| `configuration` | Logger category for configuration-related logs. |
| `errorHandling` | Logger category for error handling-related logs. |
| `logging` | Logger category for logging-related logs. |
| `configurationManagement` | Logger category for configuration management-related logs. |
| `imageProcessing` | Logger category for image processing-related logs. |
| `videoProcessing` | Logger category for video processing-related logs. |
| `audioProcessing` | Logger category for audio processing-related logs. |
| `sensors` | Logger category for sensor-related logs. |
| `camera` | Logger category for camera-related logs. |
| `location` | Logger category for location-related logs. |
| `maps` | Logger category for maps-related logs. |

##### Networking and Connectivity

| Logger Category | Description |
|------------------|-------------------------------------------------------|
| `network` | Logger category for network-related logs. |
| `api` | Logger category for API-related logs. |
| `upload` | Logger category for upload-related logs. |
| `download` | Logger category for download-related logs. |
| `sync` | Logger category for synchronisation-related logs. |
| `connectivity` | Logger category for connectivity-related logs. |
| `reachability` | Logger category for reachability-related logs. |
| `streaming` | Logger category for streaming-related logs. |
| `bluetooth` | Logger category for Bluetooth-related logs. |

##### Performance and Optimisation

| Logger Category | Description |
|---------------------|-------------------------------------------------------|
| `performance` | Logger category for performance-related logs. |
| `memoryManagement` | Logger category for memory management-related logs. |
| `concurrency` | Logger category for concurrency-related logs. |
| `threading` | Logger category for threading-related logs. |
| `debugging` | Logger category for debugging-related logs. |
| `monitoring` | Logger category for monitoring-related logs. |

##### Data Management and Persistence

| Logger Category | Description |
|-----------------------|-------------------------------------------------------|
| `coreData` | Logger category for Core Data-related logs. |
| `swiftData` | Logger category for Swift Data-related logs. |
| `database` | Logger category for database-related logs. |
| `caching` | Logger category for caching-related logs. |
| `persistence` | Logger category for persistence-related logs. |
| `serialization` | Logger category for serialisation-related logs. |
| `deserialization` | Logger category for deserialisation-related logs. |
| `parsing` | Logger category for parsing-related logs. |
| `keychain` | Logger category for keychain-related logs. |
| `userDefaults` | Logger category for UserDefaults-related logs. |
| `backup` | Logger category for backup-related logs. |
| `restore` | Logger category for restore-related logs. |

##### Security and Permissions

| Logger Category | Description |
|--------------------|-------------------------------------------------------|
| `security` | Logger category for security-related logs. |
| `encryption` | Logger category for encryption-related logs. |
| `decryption` | Logger category for decryption-related logs. |
| `permissions` | Logger category for permissions-related logs. |
| `authentication` | Logger category for authentication-related logs. |
| `authorization` | Logger category for authorisation-related logs. |

##### System and OS

| Logger Category | Description |
|---------------------|-------------------------------------------------------|
| `lifecycle` | Logger category for lifecycle-related logs. |
| `initialization` | Logger category for initialisation-related logs. |
| `deinitialization` | Logger category for de-initialisation-related logs. |
| `fileSystem` | Logger category for file system-related logs. |
| `backgroundTasks` | Logger category for background tasks-related logs. |
| `scheduling` | Logger category for scheduling-related logs. |
| `notifications` | Logger category for notifications-related logs. |
| `timers` | Logger category for timers-related logs. |

##### Testing and Validation

| Logger Category | Description |
|----------------------|-------------------------------------------------------|
| `testing` | Logger category for testing-related logs. |
| `unitTesting` | Logger category for unit testing-related logs. |
| `integrationTesting` | Logger category for integration testing-related logs. |
| `uiTesting` | Logger category for UI testing-related logs. |
| `mocking` | Logger category for mocking-related logs. |
| `stubbing` | Logger category for stubbing-related logs. |
| `validation` | Logger category for validation-related logs. |

##### UI and User Interaction

| Logger Category | Description |
|----------------------------|--------------------------------------------------|
| `ui` | Logger category for UI-related logs. |
| `gestures` | Logger category for gesture-related logs. |
| `animations` | Logger category for animation-related logs. |
| `transitions` | Logger category for transition-related logs. |
| `accessibility` | Logger category for accessibility-related logs. |
| `localization` | Logger category for localisation-related logs. |
| `internationalization` | Logger category for internationalisation-related logs. |
| `theming` | Logger category for theming-related logs. |
| `styling` | Logger category for styling-related logs. |
| `layout` | Logger category for layout-related logs. |
| `rendering` | Logger category for rendering-related logs. |

##### Utilities and Helpers

| Logger Category | Description |
|------------------|---------------------------------------------------|
| `utils` | Logger category for utility-related logs. |
| `extensions` | Logger category for extension-related logs. |
| `helpers` | Logger category for helper-related logs. |
| `factories` | Logger category for factory-related logs. |
| `builders` | Logger category for builder-related logs. |
| `commands` | Logger category for command-related logs. |
| `handlers` | Logger category for handler-related logs. |
| `middlewares` | Logger category for middleware-related logs. |
| `interceptors` | Logger category for interceptor-related logs. |

#### Custom Categories

The `LoggerCategory` struct allows users to create their own type-safe categories by simply extending the struct, and defining a new category.

If there is a duplicate category (either a new one matches pre-defined, or duplicate custom) the package will log a warning notifying you.

```swift
extension LoggerCategory {
  static let myCustomCategory = LoggerCategory("MyCustomCategory")
}

// Using the custom category
let logger = Logger(category: .myCustomCategory)
```

### LoggerManager

To initialise `LoggerManager` in your SwiftUI app, create an instance of it, specifying its parameters to tailor the logging behaviour to your needs:

```swift
import SwiftUI
import SimpleLogger

@main
struct MyApp: App {
    @StateObject private var loggerManager = LoggerManager(
        excludeSystemLogs: true, 
        filterType: .all, 
        logLevels: [.info, .error]
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loggerManager)
        }
    }
}
```

#### Parameters

| Property/Parameter | Description | Default Value | Use Case |
|-|-|-|-|
| `excludeSystemLogs` | Flag to exclude system logs from the fetched results. | `true` | Reduces noise by focusing only on app-specific logs. |
| `filterType` | Defines the type of filtering to apply to log entries. | `.specificDate` | Helps narrow down logs by specific time frames or criteria like date, range, hour, or preset filters. |
| `specificDate` | The specific date to filter logs when `filterType` is `.specificDate`. | `Date()` (current date) | Use to view logs from a particular day, useful for investigating specific dates. |
| `dateRangeStart` | The start date for filtering logs when `filterType` is `.dateRange`. | `Date()` (current date) | Sets the beginning of a date range for log filtering over a specific period. |
| `dateRangeFinish` | The end date for filtering logs when `filterType` is `.dateRange`. | `Date()` (current date) | Defines the end of a date range, useful for filtering logs between two dates. |
| `hourRangeStart` | The start time for filtering logs when `filterType` is `.hourRange`. | `Date().addingTimeInterval(-3600)` | Focuses on log entries starting from a specific hour, useful for time-specific investigations. |
| `hourRangeFinish` | The end time for filtering logs when `filterType` is `.hourRange`. | `Date()` (current time) | Specifies the end time for filtering logs within a particular hour range. |
| `selectedPreset` | Preset option to filter logs when `filterType` is `.preset`. | `.minutesFive` | Applies predefined time-based filters, convenient for quick and common log filtering scenarios. |
| `exportState` | Represents the initial state of the export process for logs. | `.ready` | Manages and tracks the state of log exporting, useful for UI elements that reflect export status. |
| `logLevels` | A set of log levels to filter log entries based on their severity. | `[]` (empty set) | Filters logs by severity (e.g., errors, warnings), focusing on specific levels like `.info` or `.error`. |
| `categoryFilters` | A set of categories to filter the logs. | `[]` (empty set) | Includes only logs from specified categories (e.g., "UI", "Network"), refining log output for analysis. |

### Log Filtering

`LoggerManager` supports various filtering options:

- **Specific Date:** Filter logs for a particular day.
- **Date Range:** Filter logs between two dates.
- **Hour Range:** Filter logs within specific hours of the day.
- **Presets:** Use predefined time intervals to filter logs.

### Export Formats

Export logs in different formats:

- **Plain Text:** Readable format with entries separated by lines.
- **JSON:** Structured data format for integration with other systems.
- **CSV:** Comma-separated values with customisable delimiters.

#### Dynamic Delimiters

Define custom delimiters for CSV exports to ensure data integrity:

```swift
let customCSV = loggerManager.exportLogs(as: .csv(.semicolon))
```


## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any features, fixes, or improvements.

## License

`SimpleLogger` is available under the MIT license. See the LICENSE file for more information.
