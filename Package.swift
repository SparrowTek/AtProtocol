// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AtProtocol",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .macCatalyst(.v17),
    ],
    products: [
        .library(
            name: "AtProtocol",
            targets: ["AtProtocol"]),
    ],
    targets: [
        .target(
            name: "AtProtocol",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
        .testTarget(
            name: "AtProtocolTests",
            dependencies: ["AtProtocol"]
        ),
    ]
)
