// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "POEditorExporter",
    dependencies: [
       .package(url: "https://github.com/apple/swift-tools-support-core.git", from: "0.0.1"),
       .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
	   .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "POEditorExporter",
            dependencies:  [
			   .product(name: "ArgumentParser", package: "swift-argument-parser"),
			   .product(name: "SwiftToolsSupport", package: "swift-tools-support-core"),
			   "RxSwift"
			]
		),
        .testTarget(
            name: "POEditorExporterTests",
            dependencies: ["POEditorExporter"]),
    ]
)
