// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "the-ping",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "the-ping",
            type: .static,
            targets: ["the-ping"]),
    ],
    dependencies: [
        // using swift lib wasn't wise when it came to building actual osquery extension
        // .package(name: "SwiftyPing", url: "https://github.com/kukushechkin/SwiftyPing", .branch("fix-observer-inform-on-success"))
    ],
    targets: [
        .target(
            name: "SimplePing",
            dependencies: []),
        .target(
            name: "the-ping",
            dependencies: ["SimplePing"],
            cxxSettings: [
                .unsafeFlags(["-fmodules", "-fcxx-modules"]),
            ]),
        .testTarget(
            name: "the-pingTests",
            dependencies: ["the-ping"],
            cxxSettings: [
                .unsafeFlags(["-fmodules", "-fcxx-modules"]),
            ]),
    ],
    cxxLanguageStandard: .cxx11
)
