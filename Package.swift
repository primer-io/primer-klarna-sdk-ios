// swift-tools-version: 5.6

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
            url: "https://github.com/klarna/klarna-mobile-sdk-spm.git",
            branch: "main")
    ],
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            dependencies: [
                .product(
                    name: "KlarnaMobileSDK",
                    package: "klarna-mobile-sdk-spm")
            ],
            path: "PrimerKlarnaSDK/Classes"
        )
    ],
    swiftLanguageVersions: [.v5]
)
