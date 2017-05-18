import PackageDescription

let package = Package(
    name: "Cairo",
    targets: [
        Target(
            name: "Cairo")
    ],
    dependencies: [
        .Package(url: "https://github.com/PureSwift/CCairo.git", majorVersion: 1),
        .Package(url: "https://github.com/PureSwift/CFontConfig.git", majorVersion: 1),
        .Package(url: "https://github.com/PureSwift/CFreeType.git", majorVersion: 1)
    ]
)
