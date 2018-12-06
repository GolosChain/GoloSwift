//
//  MicroserviceAPI.swift
//  AlignedCollectionViewFlowLayout
//
//  Created by msm72 on 12/6/18.
//

import Foundation
//import BeyovaJSON

/// Type of request parameters
typealias MicroserviceRequestParameters = (methodAPIType: MicroserviceAPIType, serviceName: String, parameters: [String?])

/// API GET methods
public indirect enum MicroserviceAPIType {
    // Microservices: Gate services
    
    /// Get secret key
    case getSecretKey()
    
    
    // Microservices: Facade services
    
    ///
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> MicroserviceRequestParameters {
        switch self {
        // Microservices: Gate services
        
        /// Template: { "id": 11, "method": "getSecret", "jsonrpc": "2.0", "params": [] }
        case .getSecretKey():   return  (methodAPIType:     self,
                                         serviceName:       "getService",
                                         parameters:        [])
            
        // Microservices: Facade services
            
        ///

        } // switch
    }
}
