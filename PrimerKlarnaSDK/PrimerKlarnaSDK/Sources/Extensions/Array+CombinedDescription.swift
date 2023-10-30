//
//  Array+CombinedDescription.swift
//  PrimerKlarnaSDK
//
//  Created by Illia Khrypunov on 30.10.2023.
//

import Foundation

extension Array where Element == Error {
    var combinedDescription: String {
        var message: String = ""
        
        self.forEach { error in
            if let primerError = error as? PrimerKlarnaErrorProtocol {
                message += "\(primerError.localizedDescription) | "
            } else {
                let nsErr = error as NSError
                message += "Domain: \(nsErr.domain), Code: \(nsErr.code), Description: \(nsErr.localizedDescription)  | "
            }
        }
        
        if message.hasSuffix(" | ") {
            message = String(message.dropLast(3))
        }
        
        return "[\(message)]"
    }
}
