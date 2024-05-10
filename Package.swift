// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SimpleLogger",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SimpleLogger",
            targets: ["SimpleLogger"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/markbattistella/PlatformChecker.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "SimpleLogger",
            dependencies: ["PlatformChecker"],
            exclude: []
        )
    ]
)
