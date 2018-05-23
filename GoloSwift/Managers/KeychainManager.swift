//
//  KeychainManager.swift
//  GoloSwift
//
//  Created by msm72 on 22.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Locksmith

public class KeychainManager {
    /// Delete stored data from Keychain
    public static func deleteData(forUserAccount userAccount: String) -> Bool {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
            Logger.log(message: "Successfully delete Login data from Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Delete Login data from Keychain error.", event: .error)
            return false
        }
    }
    
    
    /// Load data from Keychain
    public static func loadData(forUserAccount userAccount: String) -> [String: Any]? {
        return Locksmith.loadDataForUserAccount(userAccount: userAccount)
    }
    
    static func loadPostingKey(forUserAccount userAccount: String) -> String {
        var postingKey: String  =   "P5KbaLKyg7rWZNWHVNqewHqQwN7CamUfCpGqMm7872K7oieYwQsM"
        
        if let data = Locksmith.loadDataForUserAccount(userAccount: userAccount) {
            postingKey = data[secretKey] as! String
        }
        
        return postingKey
    }

    
    /// Save login data to Keychain
    public func save(_ data: [String: Any], forUserAccount userAccount: String) -> Bool {
        do {
            let postingKey = Base58().base58Decode(data: (data[secretKey] as? String)!)
            
            try Locksmith.saveData(data: [ loginKey: data[loginKey] as! String, secretKey: postingKey ], forUserAccount: userKey)
            Logger.log(message: "Successfully save Login data to Keychain.", event: .severe)
            return true
        } catch {
            Logger.log(message: "Save Login data to Keychain error.", event: .error)
            return false
        }
    }
}
