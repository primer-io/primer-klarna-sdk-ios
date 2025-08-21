# PrimerKlarnaSDK #

[![Swift](https://img.shields.io/badge/Swift-5.4_5.5_5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.4_5.5_5.6-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)

![Primer](./Resources/logo.png)

## Description ##

PrimerKlarnaSDK is is a wrapper of the KlarnaMobileSDK that exposes its functionality source. It can be used within the PrimerSDK as a separate module. Our goal is to provide binary universal framework as Swift Package and Cocoapod for further integraton into main Primer SDK.

## This repository consists of ##

- Framework:
    - PrimerKlarnaSDK Xcode project. This project contains implementation of wrapper around KlarnaMobileSDK and creates framework.
- Scripts:
    - prepare.sh - does some preparations related to removing previous xcframework
    - archive.sh - does archivation of framework project for both iOS and Simulators
    - build.sh - does creation of xcframework using archives from previous step
    - finalize.sh - removes archives, removes previous zip with xcframeworks and creates new one
    - make.sh - calls all previously described scripts in correct order
- KlarnaMobileSDK.xcframework - binary universal framework for KlarnaMobileSDK
- KlarnaCore.xcframework - binary universal framework from KlarnaCore (dependency of KlarnaMobileSDK)
- PrimerKlarnaSDK.xcframework - binary universal framework for PrimerKlarnaSDK
- XCFrameworks.zip - archive with xcframeworks (required for CocoaPod integration)

## The framework consists of ##

The framework contains implementation of wrapper classes and protocols for KlarnaMobileSDK, which is integrated inside it as a universal framework (xcframework).

### Errors ###

If any error is occurring during payment process you will get it as an object of `PrimerKlarnaError`. It implements `PrimerKlarnaErrorProtocol` and contains following properties:

```swift
public protocol PrimerKlarnaErrorProtocol: CustomNSError, LocalizedError {
    var errorId: String { get }
    var exposedError: Error { get }
    var info: [String: String]? { get }
    var diagnosticsId: String { get }
}
```

Using the information it is possible to get more details about exact error, which occured and handle it in specific way.

### ViewController ###

The framework contains already predefined `PrimerKlarnaViewController`, which contains continue button for controling payment process and `KlarnaPaymentView`, which is UI component provided by Klarna and available as a part of `KlarnaMobileSDK`. It is responsible for representation of different stages, which user need to pass through during payment process.

In order to initialize object of `PrimerKlarnaViewController` you need to do next:

```swift
let viewController = PrimerKlarnaViewController(
    delegate: self,
    paymentCategory: .payNow,
    clientToken: "CLIENT_TOKEN",
    urlScheme: "URL_SCHEME"
)
```

As a mechanism for getting callbacks from `PrimerKlarnaViewController` you can use `PrimerKlarnaViewControllerDelegate`, which contains:

1) `func primerKlarnaViewDidLoad()` - called when `KlarnaPaymentView` is loaded and available for user for further interactions.

2) `func primerKlarnaPaymentSessionCompleted(authorizationToken: String?, error: PrimerKlarnaError?)` - called when payment session completed either with error or successfully.

Next parameter, which should be passed is `paymentCategory`. It should be case from the following enum:

```swift
public enum KlarnaPaymentCategory: String {
    case payNow = "pay_now"
    case payLater = "pay_later"
    case payOverTime = "pay_over_time"
}
```

After this you need to pass client token, which is a token for Klarna payment session and can be retrieved from Primer back-end.

The last parameter, is `urlScheme` and it is optional. It should be your apps custom URL scheme `CFBundleURLSchemes`, which is required to return from external applications.

### Provider ###

Another option for integration of Klarna payments, which is available within the framework, is `PrimerKlarnaProvider`.
This approach should be used if you want to get full control over user interface and user experience during Klarna payment process and handle it inside your app.

`PrimerKlarnaProvider` implement `PrimerKlarnaProviding` protocol, which contains following functions and properties:

```swift
public protocol PrimerKlarnaProviding: AnyObject {
    // MARK: - Properties
    /**
    Can be used for getting access to KlarnaPaymentView for representation it inside the app
    */
    var paymentView: KlarnaPaymentView? { get }
    
    // MARK: - Funcs
    /**
    Create KlarnaPaymentView using predefined payment category and setting up Klarna payment events listener
    */
    func createPaymentView()
    
    /**
    Initializes payment view using client token and url schema if it is available
    */
    func initializePaymentView()
    
    /**
    Gives ability to load payment review UI inside KlarnaPaymentView if it is required
    */
    func loadPaymentReview()
    
    /**
    Loads payment view (json data can be added if it is required)
    */
    func loadPaymentView(jsonData: String?)
    
    /**
    Removes payment view from superview and deinitializes it
    */
    func removePaymentView()
    
    /**
    Authorizes payment session and gives ability to enable automatic finalization for payment
    */
    func authorize(autoFinalize: Bool, jsonData: String?)
    
    /**
    Gives ability to reauthorize payment session if it is required
    */
    func reauthorize(jsonData: String?)
    
    /**
    FInalizes payment session if it was not setup as the session to be automatically finalized on authorization stage
    */
    func finalise(jsonData: String?)
}
```

In order to create instance of `PrimerKlarnaProvider` you need to add following code:

```swift
let provider: PrimerKlarnaProviding = PrimerKlarnaProvider(
    clientToken: "CLIENT_TOKEN",
    paymentCategory: "PAYMENT_CATEGORY",
    urlScheme: "URL_SCHEME",
    delegate: self
)
```

Here client token should be fetched from Primer server along with list of payments categories. After user selects appropriate category you can create instance of `PrimerKlarnaProvider` as an object of `PrimerKlarnaProviding` protocol. URL schema is optional. 

In order to get callbacks from payment session you need to implement `PrimerKlarnaProviderDelegate`, which contains following functions:

1) `func primerKlarnaWrapperInitialized()` - called when `KlarnaPaymentView` is initialized

2) `func primerKlarnaWrapperResized(to newHeight: CGFloat)` - called whenever `KlarnaPaymentView` changes its size and can be used for layout upates

3) `func primerKlarnaWrapperLoaded()` - called whenever `KlarnaPaymentView` is loaded

4) `func primerKlarnaWrapperReviewLoaded()` - called whenever `KlarnaPaymentView` loaded in `review` state

5) `func primerKlarnaWrapperAuthorized(approved: Bool, authToken: String?, finalizeRequired: Bool)` - called whenever payment session is authorized

6) `func primerKlarnaWrapperReauthorized(approved: Bool, authToken: String?)` - called whenever payment session is reauthorized

7) `func primerKlarnaWrapperFinalized(approved: Bool, authToken: String?)` - called whenever payment session is finalized

8) `func primerKlarnaWrapperFailed(with error: PrimerKlarnaError)` - calledif any error occurs during payment process


## How to build new version of PrimerKlarnaSDK ##

Steps:

1) Open Xcode project `Framework/PrimerKlarnaSDK.xcodeproj`

2) If you need update dependencies and/or make changes in source code

3) Make new universal framework (xcframework). Run terminal and execute script:

```
cd Scripts
sh make.sh
```
As a result `PrimerKlarnaSDK.xcframework` will be built and placed in `root` folder. Also, the script will produce new `XCFrameworks.zip`, which is required for CocoaPod.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'PrimerKlarnaSDK'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Alamofire as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/primer-io/primer-klarna-sdk-ios.git", .upToNextMajor(from: "1.0.4"))
]
```

## Requirements

| Platform | Minimum Swift Version |
| --- | --- |
| iOS 14.0+| 5.5 |


## Dependencies

- KlarnaMobileSDK (included as xcframework) https://docs.klarna.com/mobile-sdk/ios/get-started/
