import PackageDescription

let package = Package(
    name: "Cairo",
    dependencies: [
        .Package(url: "https://github.com/PureSwift/CCairo.git", majorVersion: 1)
    ],
    targets: [
        Target(
            name: "Cairo")
    ],
    exclude: ["Xcode", "Sources/CairoUnitTests"]
)