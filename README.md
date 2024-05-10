<!-- markdownlint-disable MD033 MD041 -->
<div align="center">

# SimpleLogger

![Platforms](https://img.shields.io/badge/Platforms-iOS%2014+%20|%20macOS%2011+%20|%20Mac%20Catalyst%2014+%20|%20tvOS%2014+%20|%20watchOS%207+%20|%20visionOS%201+-white?labelColor=gray&style=flat)

![Languages](https://img.shields.io/badge/Languages-Swift%20|%20SwiftUI%20|%20UIKit%20|%20AppKit-white?labelColor=orange&style=flat)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

**SimpleLogger** is a centralised logging manager designed for Swift applications. It provides a flexible, environment-aware logging system that simplifies logging across different parts of an application. SimpleLogger supports conditional logging based on the development or production environment and incorporates privacy-aware logging practices.

## Features

- **Environment-Specific Logging**: Enables or disables logging based on the application's running environment — development or production.
- **Privacy-Conscious**: Supports privacy considerations in logging to protect sensitive data.
- **Flexible Logging Levels**: Includes support for multiple logging levels (info, debug, error, etc.).
- **Category-Based Logging**: Allows logs to be categorised for better organisation and filtering.

## Installation

### Swift Package Manager

You can add PlatformChecker to your project via Swift Package Manager. Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/markbattistella/SimpleLogger.git",
         from: "1.0.0"
    )
]
```

## Usage

Import SimpleLogger in the Swift file where you want to use the platform and device checks:

```swift
import SimpleLogger
```

### Example Usage

Here are some examples of how you can use SimpleLogger in your project:

```swift
// Setup logger
let logger = LogManager.shared.getLogger(
  environment: .production,
  category: .network
)

// Use logger
logger.info("Network request completed successfully.")
```

### Configuring Log Categories

Implement the `LogCategoryRepresentable` to define custom log categories:

```swift
enum AppLogCategory: String, LogCategoryRepresentable {
    case network, ui, database
    var value: String { rawValue }
}
```

## Production vs. Development

There is the parameter `environment` in the `getLogger(environment:category:)` function that allows you to filter when and if the logging should be stored.

If you set this parameter to `.development` then it will only log if you run the app in `#if DEBUG`, on a simulator, or in TestFlight.

Otherwise, if using `.production`, the logging will occur for both environments.

## Contributing

Contributions are welcome! If you have suggestions or improvements, please fork the repository and submit a pull request.

## License

PlatformChecker is released under the MIT license. See [LICENSE](https://github.com/markbattistella/SimpleLogger/blob/main/LICENCE) for details.
