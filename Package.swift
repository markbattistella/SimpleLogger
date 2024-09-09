// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleLogger",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SimpleLogger",
            targets: ["SimpleLogger"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleLogger",
            dependencies: [],
            exclude: [],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
)
