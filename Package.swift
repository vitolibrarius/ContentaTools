// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ContentaTools",
    products: [
        .library( name: "ContentaTools", targets: ["ContentaTools"]),
    ],
    dependencies: [
    ],
    targets: [
        .target( name: "ContentaTools", dependencies: []),
        .testTarget( name: "ContentaToolsTests", dependencies: ["ContentaTools"]),
    ]
)
