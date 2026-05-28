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
                "KlarnaMobileSDKFramework",
                "KlarnaCoreFramework",
                "KlarnaCoreWebViewFramework",
                "KlarnaNetworkCoreFramework",
                "KlarnaNetworkIdentityFramework",
                "KlarnaNetworkMessagingFramework",
                "KlarnaNetworkPaymentFramework",
                "KlarnaPaymentsFramework"
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
        ),
        .binaryTarget(
            name: "KlarnaCoreFramework",
            path: "./KlarnaCore.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaCoreWebViewFramework",
            path: "./KlarnaCoreWebView.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaNetworkCoreFramework",
            path: "./KlarnaNetworkCore.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaNetworkIdentityFramework",
            path: "./KlarnaNetworkIdentity.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaNetworkMessagingFramework",
            path: "./KlarnaNetworkMessaging.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaNetworkPaymentFramework",
            path: "./KlarnaNetworkPayment.xcframework"
        ),
        .binaryTarget(
            name: "KlarnaPaymentsFramework",
            path: "./KlarnaPayments.xcframework"
        )
    ]
)
