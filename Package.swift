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
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/OAuthenticator", branch: "main"),
    ],
    targets: [
        .target(
            name: "AtProtocol",
            dependencies: [
                "OAuthenticator",
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
        .testTarget(
            name: "AtProtocolTests",
            dependencies: ["AtProtocol"]
        ),
    ]
)
