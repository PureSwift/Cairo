// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cairo",
    products: [
        .library(
            name: "Cairo",
            targets: ["Cairo"]),
    ],
    targets: [
        .target(
            name: "Cairo",
            dependencies: [
                "CCairo",
                "CFontConfig",
                "CFreeType"
            ]
        ),
        .testTarget(
            name: "CairoTests",
            dependencies: [
                "Cairo"
            ]
        ),
        .systemLibrary(
            name: "CCairo",
            pkgConfig: "cairo",
            providers: [
                .brew(["cairo"]),
                .apt(["libcairo2-dev"])
            ]),
        .systemLibrary(
            name: "CFontConfig",
            pkgConfig: "fontconfig",
            providers: [
                .brew(["fontconfig"]),
                .apt(["libfontconfig-dev"])
            ]),
        .systemLibrary(
            name: "CFreeType",
            pkgConfig: "freetype",
            providers: [
                .brew(["freetype2"]),
                .apt(["libfreetype6-dev"])
            ])
    ],
    swiftLanguageVersions: [.v5]
)
