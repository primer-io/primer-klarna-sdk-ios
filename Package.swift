// swift-tools-version:5.3

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
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            dependencies: ["KlarnaMobileSDK"],
            path: "PrimerKlarnaSDK/Classes"
        ),
        .binaryTarget(
            name: "KlarnaMobileSDK",
            path: "PrimerKlarnaSDK/Frameworks/KlarnaMobileSDK.xcframework"
        ),
    ],
    
    swiftLanguageVersions: [.v5]
)
