//
//  MicroserviceMethodAPI.swift
//  AlignedCollectionViewFlowLayout
//
//  Created by msm72 on 12/6/18.
//

import Foundation
//import BeyovaJSON

/// Type of request parameters
typealias MicroserviceMethodRequestParameters = (microserviceMethodAPIType: MicroserviceMethodAPIType, nameAPI: String, parameters: [String])

/// API GET microservices methods
public indirect enum MicroserviceMethodAPIType {
    // Microservices: Gate services
    
    /// Get secret key
    case getSecretKey()
    case auth(user: String, sign: String)
    
    
    // Microservices: Facade services
    
    ///
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> MicroserviceMethodRequestParameters {
        switch self {
        // Microservices: Gate services
            
        /// Template: { "id": 11, "method": "getSecret", "jsonrpc": "2.0", "params": [] }
        case .getSecretKey():   return  (microserviceMethodAPIType:     self,
                                         nameAPI:                       "getSecret",
                                         parameters:                    [])
            
        /// Template: { "id": 11, "method": "auth", "jsonrpc": "2.0", "params": [ "user": <userNickName>, "sign": <signature> ] }
        case .auth(let userNickname, let sign):         return  (microserviceMethodAPIType:     self,
                                                                 nameAPI:                       "auth",
                                                                 parameters:                    [String(format: "user: %@, sign: %@", userNickname, sign)])
            
        // Microservices: Facade services
            
        ///
            
        } // switch
    }
}
