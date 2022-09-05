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
            targets: ["KlarnaMobileSDK"]),
    ],
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            path: "PrimerKlarnaSDK/Classes"
        ),
        .binaryTarget(
            name: "KlarnaMobileSDK",
            path: "PrimerKlarnaSDK/Frameworks/KlarnaMobileSDK.xcframework"
        ),
    ],
    
    swiftLanguageVersions: [.v5]
)
