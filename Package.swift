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
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            path: "PrimerKlarnaSDK/Classes",
            linkerSettings: [
                .linkedFramework("KlarnaMobileSDK")
            ]
        ),
        .binaryTarget(
            name: "KlarnaMobileSDK",
            path: "PrimerKlarnaSDK/Frameworks/KlarnaMobileSDK.xcframework"
        ),
    ],
    
    swiftLanguageVersions: [.v5]
)
