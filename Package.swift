// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cairo",
    dependencies: [
        .package(url: "https://github.com/PureSwift/CCairo.git", from: "1.0.0"),
        .package(url: "https://github.com/PureSwift/CFontConfig.git", from: "1.0.0"),
        .package(url: "https://github.com/PureSwift/CFreeType.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Cairo"
        )
    ]
)
