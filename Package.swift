import PackageDescription

let package = Package(
    name: "PrimerKlarnaSDK",
    defaultLocalization: "en",
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
            dependencies: [],
            path: "PrimerKlarnaSDK/Classes",
        ),
    ],
    swiftLanguageVersions: [.v5]
)
