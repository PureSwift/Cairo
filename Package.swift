// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Cairo",
    products: [
        .library(
            name: "Cairo",
            targets: ["Cairo"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/PureSwift/FontConfig.git",
            branch: "master"
        )
    ],
    targets: [
        .target(
            name: "Cairo",
            dependencies: [
                "CCairo",
                "CFreeType",
                "FontConfig"
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
            name: "CFreeType",
            pkgConfig: "freetype",
            providers: [
                .brew(["freetype2"]),
                .apt(["libfreetype6-dev"])
            ])
    ]
)
