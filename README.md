<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# SimpleLogger

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSimpleLogger%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FSimpleLogger%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`SimpleLogger` is a modern Swift logging utility built on Apple’s Unified Logging system (`OSLog`). It provides strongly typed categories, queryable log access, advanced time-based filtering, and multiple export formats, designed primarily for SwiftUI applications.

## Features

- Type-safe logger categories with duplicate detection
- Unified Logging integration (`OSLog`)
- Observable log manager for SwiftUI
- Advanced filtering
  - Specific date
  - Date range
  - Hour range
  - Rolling presets (minutes → years)
- Export formats
  - Plain text
  - JSON
  - JSON Lines (`.jsonl`)
  - CSV (configurable delimiters)
  - Optional gzip compression
- System log exclusion
- Severity-level filtering

## Installation

Add `SimpleLogger` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(
    url: "https://github.com/markbattistella/SimpleLogger", 
    from: "1.0.0"
  )
]
```

Alternatively, you can add `SimpleLogger` using Xcode by navigating to `File > Add Packages` and entering the package repository URL.

## Usage

### Basic Usage

`SimpleLogger` wraps over `OSLog.Logger` under a simplified name and provides a convenience initialiser that automatically uses your app's bundle identifier as the subsystem.

```swift
import SimpleLogger

let logger = Logger(category: .ui)
logger.info("User tapped the start button")
```

#### Logger Categories

Categories are strongly typed using `LoggerCategory`.

##### Architecture and Patterns

| Logger Category | Description |
| - | - |
| `routing` | Logger category for routing-related logs. |
| `navigation` | Logger category for navigation-related logs. |
| `stateManagement` | Logger category for state management-related logs. |
| `dependencyInjection` | Logger category for dependency injection-related logs. |
| `observers` | Logger category for observer-related logs. |
| `publishers` | Logger category for publisher-related logs. |
| `subscribers` | Logger category for subscriber-related logs. |
| `events` | Logger category for event-related logs. |
| `signals` | Logger category for signal-related logs. |

##### Miscellaneous

| Logger Category | Description |
| - | - |
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
| - | - |
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
| - | - |
| `performance` | Logger category for performance-related logs. |
| `memoryManagement` | Logger category for memory management-related logs. |
| `concurrency` | Logger category for concurrency-related logs. |
| `threading` | Logger category for threading-related logs. |
| `debugging` | Logger category for debugging-related logs. |
| `monitoring` | Logger category for monitoring-related logs. |

##### Data Management and Persistence

| Logger Category | Description |
| - | - |
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
| - | - |
| `security` | Logger category for security-related logs. |
| `encryption` | Logger category for encryption-related logs. |
| `decryption` | Logger category for decryption-related logs. |
| `permissions` | Logger category for permissions-related logs. |
| `authentication` | Logger category for authentication-related logs. |
| `authorization` | Logger category for authorisation-related logs. |

##### System and OS

| Logger Category | Description |
| - | - |
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
| - | - |
| `testing` | Logger category for testing-related logs. |
| `unitTesting` | Logger category for unit testing-related logs. |
| `integrationTesting` | Logger category for integration testing-related logs. |
| `uiTesting` | Logger category for UI testing-related logs. |
| `mocking` | Logger category for mocking-related logs. |
| `stubbing` | Logger category for stubbing-related logs. |
| `validation` | Logger category for validation-related logs. |

##### UI and User Interaction

| Logger Category | Description |
| - | - |
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
| - | - |
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

You can define your own categories safely:

```swift
extension LoggerCategory {
  static let payments = LoggerCategory("Payments")
}

let logger = Logger(category: .payments)
```

If a duplicate category is registered at runtime (case-insensitive), `SimpleLogger` logs a warning automatically.

### LoggerManager

`LoggerManager` is the central observable object for fetching, filtering, and exporting logs.

```swift
import SwiftUI
import SimpleLogger

@main
struct MyApp: App {
  @StateObject private var loggerManager = LoggerManager()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(loggerManager)
    }
  }
}
```

### Filtering Logs

Filtering is controlled by a filter kind plus associated state.

#### Filter Kinds

```swift
loggerManager.kind = .specificDate
```

Available kinds:

- `.specificDate`
- `.dateRange`
- `.hourRange`
- `.preset`

#### Specific Date

```swift
loggerManager.kind = .specificDate
loggerManager.specificDate = Date()
```

#### Date Range

```swift
loggerManager.kind = .dateRange
loggerManager.dateRangeStart = startDate
loggerManager.dateRangeEnd = endDate
```

#### Hour Range

```swift
loggerManager.kind = .hourRange
loggerManager.hourRangeDate = Date()
loggerManager.hourRangeStartHour = 9
loggerManager.hourRangeEndHour = 17
```

#### Presets

```swift
loggerManager.kind = .preset
loggerManager.preset = .lastTwentyFourHours
```

Presets range from 5 minutes up to 1 year, grouped logically for UI presentation.

### Log Levels

You can filter by severity:

```swift
loggerManager.levels = [.error, .fault]
```

Available levels:

- `debug`
- `info`
- `notice`
- `error`
- `fault`

### Fetching Logs

Fetching is explicit and cancellable.

```swift
loggerManager.fetch()
```

State exposed for UI:

- `logs`
- `isFetching`
- `hasValidResults`
- `lastError`

### Exporting Logs

Exports are asynchronous and return `Result<Data, LoggerManagerError>`.

Supported Formats

```text
.log
.json
.jsonLines
.csv(.comma | .semicolon | .tab | .pipe)
.gzip(Format)
```

#### Example

```swift
let result = await loggerManager.export(
  format: .gzip(.jsonLines)
)

switch result {
  case .success(let data):
    // write data to file
  case .failure(let error):
    print(error.localizedDescription)
}
```

#### CSV Delimiters

```text
.csv(.semicolon)
.csv(.tab)
```

All CSV values are safely quoted and escaped.

### Error Handling

Errors are surfaced via `LoggerManagerError`:

```swift
.fetch(Error)
.export(Error)
```

Each error provides a user-friendly `errorDescription`.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any features, fixes, or improvements.

## License

`SimpleLogger` is available under the MIT license. See the LICENCE file for more information.
