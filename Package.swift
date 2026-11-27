// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Cairo",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Cairo",
            targets: ["Cairo"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/PureSwift/FontConfig.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/PureSwift/swift-freetype.git",
            from: "0.1.1"
        )
    ],
    targets: [
        .target(
            name: "Cairo",
            dependencies: [
                "CCairo",
                .product(name: "FreeTypeSwift", package: "swift-freetype"),
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
            ])
    ]
)
