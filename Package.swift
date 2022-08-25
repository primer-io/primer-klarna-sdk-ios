import PackageDescription

let package = Package(
    name: "PrimerKlarnaSDK",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "PrimerKlarnaSDK",
            targets: ["PrimerKlarnaSDK"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/klarna/klarna-mobile-sdk.git", 
            .exact("2.2.2")
        )
    ],
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            dependencies: []),
        .testTarget(
            name: "PrimerKlarnaSDKTests",
            dependencies: ["PrimerKlarnaSDK"]),
    ],
    swiftLanguageVersions: [.v5]
)
