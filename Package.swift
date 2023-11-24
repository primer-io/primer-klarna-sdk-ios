// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrimerKlarnaSDK",
    products: [
        .library(
            name: "PrimerKlarnaSDK",
            targets: [
                "PrimerKlarnaSDKFramework",
                "KlarnaMobileSDKFramework"
            ]
        )
    ],
    targets: [
        .binaryTarget(
            name: "PrimerKlarnaSDKFramework",
            path: "./PrimerKlarnaSDK.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaMobileSDKFramework",
            path: "./KlarnaMobileSDK.xcframework"
        )
    ]
)
