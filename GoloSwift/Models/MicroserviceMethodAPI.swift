//
//  MicroserviceMethodAPI.swift
//  AlignedCollectionViewFlowLayout
//
//  Created by msm72 on 12/6/18.
//

import Foundation

/// Type of request parameters
typealias MicroserviceMethodRequestParameters = (microserviceMethodAPIType: MicroserviceMethodAPIType, nameAPI: String, parameters: [String])

/// API GET microservices methods
public indirect enum MicroserviceMethodAPIType {
    // Microservices: Gate services
    
    /// Get secret key
    case getSecretKey()
    
    /// Auth
    case auth(user: String, sign: String)
    
    
    // Microservices: Facade services
    
    /// Set Basic theme options
    case setBasicOptions(user: String, udid: String, darkTheme: Int)
    case getBasicOptions(user: String, udid: String)
    
    ///
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> MicroserviceMethodRequestParameters {
        switch self {
            // Microservices: Gate services
            
        /// Template: { "id": 11, "method": "getSecret", "jsonrpc": "2.0", "params": { } }
        case .getSecretKey():   return  (microserviceMethodAPIType:     self,
                                         nameAPI:                       "getSecret",
                                         parameters:                    [])
            
        /// Template: { "id": 11, "method": "auth", "jsonrpc": "2.0", "params": { "user": <userNickName>, "sign": <signature> } }
        case .auth(let userNickname, let sign):         return  (microserviceMethodAPIType:     self,
                                                                 nameAPI:                       "auth",
                                                                 parameters:                    [String(format: "user\": \"%@\", \"sign\": \"%@", userNickname, sign)])
            
        // Microservices: Facade services
            
        /// Template: { "id": 9, "method": "setOptions", "jsonrpc": "2.0", "params": { "profile": <userNickName-deviceUDID>, "basic": { "theme": <Bool> } } }
        case .setBasicOptions(let userNickName, let deviceUDID, let isDarkTheme):
            return  (microserviceMethodAPIType:     self,
                     nameAPI:                       "setOptions",
                     parameters:                    [ String(format: "profile\": \"%@-%@\", \"basic\": [\"theme\": %d]", userNickName, deviceUDID, isDarkTheme) ])
            
        /// Template { "id":9, "method": "getOptions","jsonrpc": "2.0", "params": { "profile": <userNickName-deviceUDID> } }
        case .getBasicOptions(let userNickName, let deviceUDID):
            return  (microserviceMethodAPIType:     self,
                     nameAPI:                       "getOptions",
                     parameters:                    [ String(format: "profile\": \"%@-%@", userNickName, deviceUDID) ])
            
        } // switch
    }
}
