// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "single-ping-lib",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "single-ping-lib",
            type: .static,
            targets: ["single-ping-lib"]),
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
            name: "single-ping-lib",
            dependencies: ["SimplePing"],
            cxxSettings: [
                .unsafeFlags(["-fmodules", "-fcxx-modules"]),
            ]),
        .testTarget(
            name: "single-ping-libTests",
            dependencies: ["single-ping-lib"],
            cxxSettings: [
                .unsafeFlags(["-fmodules", "-fcxx-modules"]),
            ]),
    ],
    cxxLanguageStandard: .cxx11
)