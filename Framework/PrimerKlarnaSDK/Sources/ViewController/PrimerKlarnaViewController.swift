//
//  PrimerKlarnaViewController.swift
//  PrimerKlarnaSDK
//
//  Created by Illia Khrypunov on 30.10.2023.
//

#if canImport(UIKit)

import UIKit
import KlarnaMobileSDK

// MARK: - KlarnaPaymentCategory
public enum KlarnaPaymentCategory: String {
    case payNow = "pay_now"
    case payLater = "pay_later"
    case payOverTime = "pay_over_time"
}

// MARK: - PrimerKlarnaViewControllerDelegate
public protocol PrimerKlarnaViewControllerDelegate: AnyObject {
    func primerKlarnaViewDidLoad()
    func primerKlarnaPaymentSessionCompleted(authorizationToken: String?, error: PrimerKlarnaError?)
}

// MARK: - PrimerKlarnaViewController
public class PrimerKlarnaViewController: UIViewController {
    // MARK: - Properties
    private let paymentCategory: KlarnaPaymentCategory
    private let clientToken: String
    private let urlScheme: String?
    
    // MARK: - Delegate
    private weak var delegate: PrimerKlarnaViewControllerDelegate?
    
    // MARK: - Subviews
    private let continueButton = UIButton()
    private var klarnaPaymentView: KlarnaPaymentView!
    
    // MARK: - Constraints
    private var klarnaPaymentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    public init(
        delegate: PrimerKlarnaViewControllerDelegate,
        paymentCategory: KlarnaPaymentCategory,
        clientToken: String,
        urlScheme: String?
    ) {
        self.delegate = delegate
        self.paymentCategory = paymentCategory
        self.clientToken = clientToken
        self.urlScheme = urlScheme
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
    }
}

// MARK: - Private
private extension PrimerKlarnaViewController {
    func setupBaseAppearance() {
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: Constant.viewHeight).isActive = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constant.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constant.stackViewTopOffset
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constant.stackViewSideOffset
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constant.stackViewSideOffset
            ),
            stackView.bottomAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constant.stackViewBottomOffset
            )
        ])
        
        klarnaPaymentView = KlarnaPaymentView(category: paymentCategory.rawValue, eventListener: self)
        klarnaPaymentView.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.isEnabled = false
        continueButton.setTitle(Constant.continueButtonTitle, for: .normal)
        continueButton.backgroundColor = Constant.continueButtonDisabledBackgroundColor
        continueButton.addTarget(self, action: #selector(continueButtonTapped(_:)), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(klarnaPaymentView)
        stackView.addArrangedSubview(continueButton)
        
        let continueButtonHeightConstraint = continueButton.heightAnchor.constraint(equalToConstant: Constant.continueButtonHeight)
        continueButtonHeightConstraint.priority = Constant.continueButtonHeightPriority
        continueButtonHeightConstraint.isActive = true
        
        klarnaPaymentViewHeightConstraint = klarnaPaymentView.heightAnchor.constraint(equalToConstant: 0)
        klarnaPaymentViewHeightConstraint.priority = Constant.klarnaPaymentViewHeightPriority
        klarnaPaymentViewHeightConstraint.isActive = true
        
        if let urlScheme = urlScheme, let url = URL(string: urlScheme) {
            klarnaPaymentView.initialize(clientToken: clientToken, returnUrl: url)
        } else {
            klarnaPaymentView.initialize(clientToken: clientToken)
        }
    }
}

// MARK: - Actions
private extension PrimerKlarnaViewController {
    @objc func continueButtonTapped(_ sender: UIButton) {
        klarnaPaymentView.authorize(autoFinalize: true, jsonData: nil)
    }
}

// MARK: - KlarnaPaymentEventListener
extension PrimerKlarnaViewController: KlarnaPaymentEventListener {
    public func klarnaInitialized(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        continueButton.backgroundColor = Constant.continueButtonEnabledBackgroundColor
        continueButton.isEnabled = true
        klarnaPaymentView.load()
    }
    
    public func klarnaLoaded(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        delegate?.primerKlarnaViewDidLoad()
    }
    
    public func klarnaLoadedPaymentReview(paymentView: KlarnaMobileSDK.KlarnaPaymentView) {
        debugPrint("Klarna loaded payment review")
    }
    
    public func klarnaAuthorized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?,
        finalizeRequired: Bool
    ) {
        if let authToken = authToken {
            delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: authToken, error: nil)
        } else {
            if finalizeRequired {
                klarnaPaymentView.finalise()
            } else {
                let error = PrimerKlarnaError.userNotApproved(userInfo: nil)
                delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: nil, error: error)
            }
        }
    }
    
    public func klarnaReauthorized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?
    ) {
        if let authToken = authToken {
            delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: authToken, error: nil)
        } else {
            let error = PrimerKlarnaError.userNotApproved(userInfo: nil)
            delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: nil, error: error)
        }
    }
    
    public func klarnaFinalized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        approved: Bool,
        authToken: String?
    ) {
        if let authToken = authToken {
            delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: authToken, error: nil)
        } else {
            let error = PrimerKlarnaError.userNotApproved(userInfo: nil)
            delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: nil, error: error)
        }
    }
    
    public func klarnaResized(
        paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        to newHeight: CGFloat
    ) {
        klarnaPaymentViewHeightConstraint.constant = newHeight
    }
    
    public func klarnaFailed(
        inPaymentView paymentView: KlarnaMobileSDK.KlarnaPaymentView,
        withError error: KlarnaMobileSDK.KlarnaPaymentError
    ) {
        let error = PrimerKlarnaError.klarnaSdkError(errors: [error], userInfo: nil)
        delegate?.primerKlarnaPaymentSessionCompleted(authorizationToken: nil, error: error)
    }
}

// MARK: - View constants
private enum Constant {
    static let viewHeight: CGFloat = UIScreen.main.bounds.height - 80
    
    static let stackViewSpacing: CGFloat = 20.0
    static let stackViewTopOffset: CGFloat = 20.0
    static let stackViewSideOffset: CGFloat = 20.0
    static let stackViewBottomOffset: CGFloat = 20.0
    
    static let continueButtonTitle: String = "Continue"
    static let continueButtonDisabledBackgroundColor: UIColor = UIColor(red: 168 / 255, green: 170 / 255, blue: 172 / 255, alpha: 1.0)
    static let continueButtonEnabledBackgroundColor: UIColor = UIColor.black
    static let continueButtonHeight: CGFloat = 45.0
    static let continueButtonHeightPriority: UILayoutPriority = .init(1000)
    
    static let klarnaPaymentViewHeightPriority: UILayoutPriority = .init(900)
}

#endif
