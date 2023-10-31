//
//  PrimerKlarnaWrapper.swift
//  PrimerKlarnaSDK
//
//  Created by Illia Khrypunov on 30.10.2023.
//

import Foundation
import KlarnaMobileSDK

// MARK: - PrimerKlarnaWrapper
public protocol PrimerKlarnaWrapper: AnyObject {
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

// MARK: - PrimerKlarnaWrapperDelegate
public protocol PrimerKlarnaWrapperDelegate: AnyObject {
    func primerKlarnaWrapperInitialized()
    func primerKlarnaWrapperResized(to newHeight: CGFloat)
    
    func primerKlarnaWrapperLoaded()
    func primerKlarnaWrapperReviewLoaded()
    
    func primerKlarnaWrapperAuthorized(approved: Bool, authToken: String?, finalizeRequired: Bool)
    func primerKlarnaWrapperReauthorized(approved: Bool, authToken: String?)
    func primerKlarnaWrapperFinalized(approved: Bool, authToken: String?)
    
    func primerKlarnaWrapperFailed(with error: PrimerKlarnaError)
}

// MARK: - PrimerKlarnaWrapperImpl
public class PrimerKlarnaWrapperImpl: PrimerKlarnaWrapper {
    // MARK: - Properties
    private let clientToken: String
    private let paymentCategory: String
    private let urlScheme: String?
    
    // MARK: - Delegate
    private weak var delegate: PrimerKlarnaWrapperDelegate?
    
    // MARK: - Subviews
    public var paymentView: KlarnaPaymentView?
    
    // MARK: - Init
    public init(
        clientToken: String,
        paymentCategory: String,
        urlScheme: String? = nil,
        delegate: PrimerKlarnaWrapperDelegate
    ) {
        self.clientToken = clientToken
        self.paymentCategory = paymentCategory
        self.urlScheme = urlScheme
        self.delegate = delegate
    }
}

// MARK: - Payment view rendering
public extension PrimerKlarnaWrapperImpl {
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
public extension PrimerKlarnaWrapperImpl {
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
extension PrimerKlarnaWrapperImpl: KlarnaPaymentEventListener {
    public func klarnaInitialized(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        delegate?.primerKlarnaWrapperInitialized()
    }
    
    public func klarnaLoaded(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        delegate?.primerKlarnaWrapperLoaded()
    }
    
    public func klarnaLoadedPaymentReview(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        delegate?.primerKlarnaWrapperReviewLoaded()
    }
    
    public func klarnaAuthorized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?,
        finalizeRequired: Bool
    ) {
        delegate?.primerKlarnaWrapperAuthorized(
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
        delegate?.primerKlarnaWrapperReauthorized(
            approved: approved,
            authToken: authToken
        )
    }
    
    public func klarnaFinalized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?
    ) {
        delegate?.primerKlarnaWrapperFinalized(
            approved: approved,
            authToken: authToken
        )
    }
    
    public func klarnaResized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        to newHeight: CGFloat
    ) {
        delegate?.primerKlarnaWrapperResized(to: newHeight)
    }
    
    public func klarnaFailed(
        inPaymentView paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        withError error: KlarnaMobileSDK.KlarnaPaymentError
    ) {
        let error = PrimerKlarnaError.klarnaSdkError(errors: [error], userInfo: nil)
        delegate?.primerKlarnaWrapperFailed(with: error)
    }
}
