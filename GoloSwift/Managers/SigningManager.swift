//
//  SigningManager.swift
//  GoloSwift
//
//  Created by msm72 on 01.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import secp256k1
import Foundation
import CryptoSwift

public class SigningManager {
    /**
     ECC signing serialized buffer of transaction.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return transaction signature.
     
     */
    public static func signingECC(messageSHA256: [Byte], userName: String) -> String? {
        if let privateKeyString = KeychainManager.loadPrivateKey(forUserName: userName) {
            let privateKeyData: [Byte] =  GSBase58().base58Decode(data: privateKeyString)
            
            Logger.log(message: "\nsigningECC - privateKey:\n\t\(privateKeyString)\n", event: .debug)
            Logger.log(message: "\nsigningECC - privateKeyData:\n\t\(privateKeyData.toHexString())\n", event: .debug)
            
            var index: Int = 0
            var extra: [Byte]?
            var loopCounter: Byte = 0
            var recoveryID: Int32 = 0
            var isRecoverable: Bool = false
            var signature = secp256k1_ecdsa_recoverable_signature()             // sig
            let ctx: OpaquePointer = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))
            
            while (!(isRecoverable && isCanonical(signature: signature))) {
                if (loopCounter == 0xff) {
                    index += 1
                    loopCounter = 0
                }
                
                if (loopCounter > 0) {
                    extra = [Byte].add(randomElementsCount: 32)             // new bytes[32]
                }
                
                loopCounter += 1
                isRecoverable = (secp256k1_ecdsa_sign_recoverable(ctx, &signature, messageSHA256, privateKeyData, nil, extra) as NSNumber).boolValue
                Logger.log(message: "\nsigningECC - extra:\n\t\(String(describing: extra?.toHexString()))\n", event: .debug)
                Logger.log(message: "\nsigningECC - sig.data:\n\t\(signature.data))\n", event: .debug)
            }
            
            var output65: [Byte] = [Byte].init(repeating: 0, count: 65)     // add(randomElementsCount: 65)         // new bytes[65]
            secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, &output65[1], &recoveryID, &signature)
            
            // 4 - compressed | 27 - compact
            Logger.log(message: "\nsigningECC - output65-1:\n\t\(output65.toHexString())\n", event: .debug)
            output65[0] = Byte(recoveryID + 4 + 27)                             // (byte)(recoveryId + 4 + 27)
            Logger.log(message: "\nsigningECC - output65-2:\n\t\(output65.toHexString())\n", event: .debug)
            Logger.log(message: "\ntx - ready:\n\t\(self)\n", event: .debug)
            
            return output65.toHexString()
        }
        
        return nil
    }
    
    /// Service function from Python
    private static func isCanonical(signature: secp256k1_ecdsa_recoverable_signature) -> Bool {
        return  !((signature.data.31 & 0x80) > 0)   &&
                !(signature.data.31 == 0)           &&
                !((signature.data.30 & 0x80) > 0)   &&
                !((signature.data.63 & 0x80) > 0)   &&
                !(signature.data.63 == 0)           &&
                !((signature.data.62 & 0x80) > 0)
    }
}
