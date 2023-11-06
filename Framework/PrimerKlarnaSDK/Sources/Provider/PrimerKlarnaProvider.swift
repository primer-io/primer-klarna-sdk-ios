//
//  PrimerKlarnaProvider.swift
//  PrimerKlarnaSDK
//
//  Created by Illia Khrypunov on 30.10.2023.
//

import Foundation
import KlarnaMobileSDK

// MARK: - PrimerKlarnaProviding
public protocol PrimerKlarnaProviding: AnyObject {
    // MARK: - Properties
    var paymentView: KlarnaPaymentView? { get }
    
    // MARK: - Funcs
    func createPaymentView()
    func initializePaymentView()
    func loadPaymentReview()
    func loadPaymentView(jsonData: String?)
    func removePaymentView()
    
    func authorize(autoFinalize: Bool, jsonData: String?)
    func reauthorize(jsonData: String?)
    func finalise(jsonData: String?)
}

// MARK: - PrimerKlarnaProviderDelegate
public protocol PrimerKlarnaProviderPaymentViewDelegate: AnyObject {
    func primerKlarnaWrapperInitialized()
    func primerKlarnaWrapperResized(to newHeight: CGFloat)
    
    func primerKlarnaWrapperLoaded()
    func primerKlarnaWrapperReviewLoaded()
}

public protocol PrimerKlarnaProviderAuthorizationDelegate: AnyObject {
    func primerKlarnaWrapperAuthorized(approved: Bool, authToken: String?, finalizeRequired: Bool)
    func primerKlarnaWrapperReauthorized(approved: Bool, authToken: String?)
}

public protocol PrimerKlarnaProviderFinalizationDelegate: AnyObject {
    func primerKlarnaWrapperFinalized(approved: Bool, authToken: String?)
}

public protocol PrimerKlarnaProviderErrorDelegate: AnyObject {
    func primerKlarnaWrapperFailed(with error: PrimerKlarnaError)
}

public typealias PrimerKlarnaProviderDelegate = PrimerKlarnaProviderPaymentViewDelegate &
                                                PrimerKlarnaProviderAuthorizationDelegate &
                                                PrimerKlarnaProviderFinalizationDelegate &
                                                PrimerKlarnaProviderErrorDelegate

// MARK: - PrimerKlarnaProvider
public class PrimerKlarnaProvider: PrimerKlarnaProviding {
    // MARK: - Properties
    private let clientToken: String
    private let paymentCategory: String
    private let urlScheme: String?
    
    // MARK: - Delegate
    public weak var paymentViewDelegate: PrimerKlarnaProviderPaymentViewDelegate?
    public weak var authorizationDelegate: PrimerKlarnaProviderAuthorizationDelegate?
    public weak var finalizationDelegate: PrimerKlarnaProviderFinalizationDelegate?
    public weak var errorDelegate: PrimerKlarnaProviderErrorDelegate?
    
    // MARK: - Subviews
    public var paymentView: KlarnaPaymentView?
    
    // MARK: - Init
    public init(
        clientToken: String,
        paymentCategory: String,
        urlScheme: String? = nil
    ) {
        self.clientToken = clientToken
        self.paymentCategory = paymentCategory
        self.urlScheme = urlScheme
    }
}

// MARK: - Payment view rendering
public extension PrimerKlarnaProvider {
    func createPaymentView() {
        if let urlScheme = urlScheme, let returnUrl = URL(string: urlScheme) {
            paymentView = KlarnaPaymentView(
                category: paymentCategory,
                returnUrl: returnUrl,
                eventListener: self
            )
        } else {
            paymentView = KlarnaPaymentView(
                category: paymentCategory,
                eventListener: self
            )
        }
    }
    
    func initializePaymentView() {
        if let urlScheme = urlScheme, let returnUrl = URL(string: urlScheme) {
            paymentView?.initialize(clientToken: clientToken, returnUrl: returnUrl)
        } else {
            paymentView?.initialize(clientToken: clientToken)
        }
    }
    
    func loadPaymentReview() {
        paymentView?.loadPaymentReview()
    }
    
    func loadPaymentView(jsonData: String? = nil) {
        paymentView?.load(jsonData: jsonData)
    }
    
    func removePaymentView() {
        paymentView?.removeFromSuperview()
        paymentView = nil
    }
}

// MARK: - Authorizing the session
public extension PrimerKlarnaProvider {
    func authorize(autoFinalize: Bool = true, jsonData: String? = nil) {
        paymentView?.authorize(autoFinalize: autoFinalize, jsonData: jsonData)
    }
    
    func reauthorize(jsonData: String? = nil) {
        paymentView?.reauthorize(jsonData: jsonData)
    }
    
    func finalise(jsonData: String? = nil) {
        paymentView?.finalise(jsonData: jsonData)
    }
}

// MARK: - KlarnaPaymentEventListener
extension PrimerKlarnaProvider: KlarnaPaymentEventListener {
    public func klarnaInitialized(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        paymentViewDelegate?.primerKlarnaWrapperInitialized()
    }
    
    public func klarnaLoaded(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        paymentViewDelegate?.primerKlarnaWrapperLoaded()
    }
    
    public func klarnaLoadedPaymentReview(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        paymentViewDelegate?.primerKlarnaWrapperReviewLoaded()
    }
    
    public func klarnaAuthorized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?,
        finalizeRequired: Bool
    ) {
        authorizationDelegate?.primerKlarnaWrapperAuthorized(
            approved: approved,
            authToken: authToken,
            finalizeRequired: finalizeRequired
        )
    }
    
    public func klarnaReauthorized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?
    ) {
        authorizationDelegate?.primerKlarnaWrapperReauthorized(
            approved: approved,
            authToken: authToken
        )
    }
    
    public func klarnaFinalized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?
    ) {
        finalizationDelegate?.primerKlarnaWrapperFinalized(
            approved: approved,
            authToken: authToken
        )
    }
    
    public func klarnaResized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        to newHeight: CGFloat
    ) {
        paymentViewDelegate?.primerKlarnaWrapperResized(to: newHeight)
    }
    
    public func klarnaFailed(
        inPaymentView paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        withError error: KlarnaMobileSDK.KlarnaPaymentError
    ) {
        let error = PrimerKlarnaError.klarnaSdkError(errors: [error], userInfo: nil)
        errorDelegate?.primerKlarnaWrapperFailed(with: error)
    }
}
