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
        .library(
            name: "KlarnaMobileSDK",
            targets: ["KlarnaMobileSDK"])
    ],
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            path: "PrimerKlarnaSDK/Classes"
        ),
        .binaryTarget(
            name: "KlarnaMobileSDK",
            url: "https://github.com/klarna/klarna-mobile-sdk/releases/download/2.2.2/KlarnaMobileSDK-full.xcframework.zip",
            checksum: "0dbc22622590c4010539b5a84ccf0a1b9aecc46c50ac86d84c6b6314fea4285c"
        ),

    ],
    swiftLanguageVersions: [.v5]
)
