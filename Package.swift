// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrimerKlarnaSDK",
    products: [
        .library(
            name: "PrimerKlarnaSDK",
            targets: [
                "PrimerKlarnaSDK"
            ]
        ),
    ],
    targets: [
        .target(
            name: "PrimerKlarnaSDK",
            dependencies: []
        )
    ]
)
