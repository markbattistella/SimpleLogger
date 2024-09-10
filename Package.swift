// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SimpleLogger",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
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
