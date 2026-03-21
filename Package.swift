// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SimpleLogger",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SimpleLogger", targets: ["SimpleLogger"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleLogger",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        )
    ]
)
