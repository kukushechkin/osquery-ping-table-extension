// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "the-ping",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "the-ping",
            targets: ["the-ping"]),
    ],
    dependencies: [
        .package(name: "SwiftyPing", url: "https://github.com/kukushechkin/SwiftyPing", .branch("fix-observer-inform-on-success"))
    ],
    targets: [
        .target(
            name: "swifty-ping-wrapper",
            dependencies: ["SwiftyPing"]
        ),
        .target(
            name: "the-ping",
            dependencies: ["swifty-ping-wrapper"],
            cxxSettings: [
                .unsafeFlags(["-fmodules", "-fcxx-modules"]),
            ]),
        .testTarget(
            name: "the-pingTests",
            dependencies: ["the-ping"],
            cxxSettings: [
                .unsafeFlags(["-fmodules", "-fcxx-modules"]),
            ]),
    ]
)
