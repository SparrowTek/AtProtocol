// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
    dependencies: [],
    targets: [
        .target(
            name: "AtProtocol",
            dependencies: []),
        .testTarget(
            name: "AtProtocolTests",
            dependencies: ["AtProtocol"]),
    ]
)
