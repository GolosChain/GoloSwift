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

public struct Attachment {
    // MARK: - Properties
    public var markdownValue: String?
    public let origin: Any
    
    // MARK: - Class Initialization
    public init(markdownValue: String? = nil, origin: Any) {
        self.markdownValue  =   markdownValue
        self.origin         =   origin
    }
    
    
    // MARK: - Custom Functions
    public static func createURL(forImage image: UIImage, userName: String) -> String? {
        // Create prefix
        let imagePrefix: [Byte]     =   [UInt8]("ImageSigningChallenge".utf8)
        Logger.log(message: "\nimagePrefix:\n\t\(imagePrefix.toHexString())\n", event: .debug)
        
        // Concatenation bytes
        guard let imageDatas = UIImageJPEGRepresentation(image, 1.0) else { return nil }
        
        let imageData: [Byte]       =   getBytes(fromImageData: imageDatas as NSData)
        let concatenation: [Byte]   =   imagePrefix + imageData
        
        // SHA256
        let concatenationSHA256: [Byte]     =   concatenation.sha256()
        
        // ECC signing
        guard let signature = SigningManager.signingECC(messageSHA256: concatenationSHA256, userName: userName) else {
            return nil
        }
        
        Logger.log(message: "\nsignature:\n\t\(signature)\n", event: .debug)
        
        return signature
    }
    
    private static func getBytes(fromImageData imageData: NSData) -> [Byte] {
        // the number of elements:
        let count       =   imageData.length / MemoryLayout<Byte>.size
        
        // create array of appropriate length:
        var bytes       =   [Byte](repeating: 0, count: count)
        
        // copy bytes into array
        imageData.getBytes(&bytes, length:count)
        
        var byteArray   =   [Byte]()
        
        for i in 0..<count {
            byteArray.append(bytes[i])
        }
        
        return byteArray
    }
}
