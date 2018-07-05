//
//  KeychainManager.swift
//  GoloSwift
//
//  Created by msm72 on 22.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Locksmith
import Foundation

public class KeychainManager {
    /// Create key name
    private func createKey(_ type: PrivateKeyType, userName: String) -> String {
        return String(format: "%@ - %f", userName, type.rawValue)
    }
    
    
    /// Delete stored data from Keychain
    public static func deleteKey(byType type: PrivateKeyType, forUserName userName: String) -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: createKey(type, userName))
            Logger.log(message: "Successfully delete Login data from Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Delete Login data from Keychain error.", event: .error)
            return false
        }
    }
    
    
    /// Load data from Keychain
    public static func loadKey(byType type: PrivateKeyType, forUserName userName: String) -> [String: Any]? {
        return Locksmith.loadDataForUserAccount(userAccount: createKey(type, userName))
    }
    
//    static func loadPrivateKey(byType type: PrivateKeyType, andUserName userName: String) -> String {
//        var privateKey: String = String()
//
//        if let data = Locksmith.loadDataForUserAccount(userAccount: createKey(type, userName)) {
//            privateKey = data[secretKey] as! String
//        }
//
//        return privateKey
//    }

    
    /// Save login data to Keychain
    public func save(_ key: String, withType type: PrivateKeyType, forUserName userName: String) -> Bool {
        do {
            let privateKey = Base58().base58Decode(data: (data[secretKey] as? String)!)
            
            try Locksmith.saveData(data: Data(key.utf8), forUserAccount: createKey(type, userName))
            Logger.log(message: "Successfully save Login data to Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Save Login data to Keychain error.", event: .error)
            return false
        }
    }
}
