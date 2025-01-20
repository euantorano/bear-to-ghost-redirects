// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = Package(
    name: "BearToGhostRedirects",
    products: [
        .executable(
            name: "bear-to-ghost", 
            targets: ["BearToGhostRedirects"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.10.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "BearToGhostRedirects",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftCSV", package: "SwiftCSV"),
                .product(name: "Yams", package: "Yams")
            ]
        ),
    ]
)
