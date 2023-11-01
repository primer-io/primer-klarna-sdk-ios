//
//  PrimerKlarnaError.swift
//  PrimerKlarnaSDK
//
//  Created by Illia Khrypunov on 30.10.2023.
//

import Foundation

// MARK: - PrimerKlarnaErrorProtocol
public protocol PrimerKlarnaErrorProtocol: CustomNSError, LocalizedError {
    var errorId: String { get }
    var exposedError: Error { get }
    var info: [String: String]? { get }
    var diagnosticsId: String { get }
}
 
// MARK: - PrimerKlarnaError
public enum PrimerKlarnaError: PrimerKlarnaErrorProtocol {
    case userNotApproved(userInfo: [String: String]?)
    case klarnaSdkError(errors: [Error], userInfo: [String: String]?)

    // MARK: - Properties
    public var errorId: String {
        switch self {
        case .userNotApproved:
            return "klarna-user-not-approved"
        case .klarnaSdkError:
            return "klarna-sdk-error"
        }
    }
    
    public var info: [String: String]? {
        var tmpUserInfo: [String: String] = ["createdAt": Date().toString()]
        
        switch self {
        case .userNotApproved(let userInfo),
                .klarnaSdkError(_, let userInfo):
            tmpUserInfo = tmpUserInfo.merging(userInfo ?? [:]) { (_, new) in new }
            tmpUserInfo["diagnosticsId"] = self.diagnosticsId
        }
        
        return tmpUserInfo
    }
    
    public var diagnosticsId: String {
        return UUID().uuidString
    }
    
    public var exposedError: Error {
        return self
    }
    
    public var errorDescription: String? {
        switch self {
        case .userNotApproved:
            return "[\(errorId)] User is not approved to perform Klarna payments (diagnosticsId: \(self.diagnosticsId)"
        case .klarnaSdkError(let errors, _):
            return "[\(errorId)] Multiple errors occured: \(errors.combinedDescription) (diagnosticsId: \(self.diagnosticsId)"
        }
    }
}
