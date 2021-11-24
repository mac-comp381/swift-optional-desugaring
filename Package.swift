// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftHomework",
    products: [
        .library(
            name: "OptionalDesugaring",
            targets: ["OptionalDesugaring"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "OptionalDesugaring",
            dependencies: []),
        .testTarget(
            name: "OptionalDesugaringTests",
            dependencies: ["OptionalDesugaring"]),
    ]
)
