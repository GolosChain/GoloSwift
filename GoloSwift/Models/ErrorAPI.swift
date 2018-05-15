//
//  ErrorAPI.swift
//  Golos
//
//  Created by msm72 on 17.04.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
//import Localize_Swift

public enum ErrorAPI: Error {
    case requestFailed(message: String)
    case jsonConversionFailure(message: String)
    case invalidData(message: String)
    case responseUnsuccessful(message: String)
    case jsonParsingFailure(message: String)
    case signingECCKeychainPostingKeyFailure(message: String)

    var caseInfo: (title: String, message: String) {
        switch self {
        case .requestFailed(let message):
//            return (title: "Request Failed".localized(), message: message)
            return (title: "Request Failed", message: message)

        case .invalidData(let message):
//            return (title: "Invalid Data".localized(), message: message)
            return (title: "Invalid Data", message: message)

        case .responseUnsuccessful(let message):
//            return (title: "Response Unsuccessful".localized(), message: message)
            return (title: "Response Unsuccessful", message: message)

        case .jsonParsingFailure(let message):
//            return (title: "JSON Parsing Failure".localized(), message: message)
            return (title: "JSON Parsing Failure", message: message)

        case .jsonConversionFailure(let message):
//            return (title: "JSON Conversion Failure".localized(), message: message)
            return (title: "JSON Conversion Failure", message: message)

        case .signingECCKeychainPostingKeyFailure(let message):
//            return (title: "Keychain Posting Key Failure".localized(), message: message)
            return (title: "Keychain Posting Key Failure", message: message)
        }
    }
}
