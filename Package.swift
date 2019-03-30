// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cairo",
    dependencies: [
        .package(url: "https://github.com/PureSwift/CCairo.git", .revision("2051a137b52995d7795c0dc9c08cd2ea2a2b570c")),
        .package(url: "https://github.com/PureSwift/CFontConfig.git", .revision("f47c3ea87307478428df762dc2e181c12643a884")),
        .package(url: "https://github.com/PureSwift/CFreeType.git", .revision("a8c830218999af31691e154cecae783bae1f0ab9"))
    ],
    products: [
        .library(name: "Cairo", targets: ["Cairo"])
    ],
    targets: [
        .target(
            name: "Cairo",
            dependencies: ["CCairo", "CFontConfig", "CFreeType"]
        )
    ]
)
