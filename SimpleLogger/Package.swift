// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SimpleLoggerPackage",
    platforms: [
        .iOS(.v17),
        .macCatalyst(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SimpleLogger", targets: ["SimpleLogger"]),
        .library(name: "SimpleLoggerUI", targets: ["SimpleLoggerUI"])
    ],
    targets: [
        .target(name: "SimpleLogger"),
        .target(name: "SimpleLoggerUI", dependencies: ["SimpleLogger"])
    ]
)
