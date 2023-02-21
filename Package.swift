// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "POEditor",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3"),
        .package(url: "https://github.com/mxcl/Path.swift", from: "1.4.0"),
        .package(url: "https://github.com/jkandzi/Progress.swift", from: "0.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "POEditor",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
                .product(name: "Progress", package: "Progress.swift"),
            ]),
        .testTarget(
            name: "POEditorTests",
            dependencies: ["POEditor"]),
    ]
)
