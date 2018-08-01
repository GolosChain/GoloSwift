//
//  Attachment.swift
//  Golos
//
//  Created by msm72 on 01.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import secp256k1
import CryptoSwift

public enum AttachmentType {
    case link
    case image
}

public struct Attachment {
    // MARK: - Properties
    public let key: String
    public let range: NSRange
    public var value: String
    public let type: AttachmentType
    
    
    // MARK: - Class Initialization
    public init(key: String, range: NSRange, value: String, type: AttachmentType) {
        self.key        =   key
        self.range      =   range
        self.value      =   value
        self.type       =   type
    }
    
    
    // MARK: - Custom Functions
    public func createURL(forImage: UIImage) -> String {
        // Create prefix
        let imagePrefix: [Byte]     =   "ImageSigningChallenge".hexBytes
        Logger.log(message: "\nimagePrefix:\n\t\(imagePrefix.toHexString())\n", event: .debug)

        // Concatenation bytes
        let imageData: [Byte]       =   Data(base64Encoded: UIImagePNGRepresentation(image))
        let concatenation: [Byte]   =   imagePrefix.append(contentsOf: imageData)
        Logger.log(message: "\nconcatenation:\n\t\(concatenation.toHexString())\n", event: .debug)

        // SHA256
        let concatenationSHA256: [Byte]     =   concatenation.sha256()
        Logger.log(message: "\nconcatenationSHA256:\n\t\(concatenationSHA256.toHexString())\n", event: .debug)
        
        // ECC signing
        let signature   =   SigningManager.signingECC(messageSHA256: concatenationSHA256)
        Logger.log(message: "\nsignature:\n\t\(signature)\n", event: .debug)

        return signature
    }
}
