//
//  MethodAPI.swift
//  GoloSwift
//
//  Created by msm72 on 12.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//

import Foundation
import BeyovaJSON

/// Type of request parameters
typealias RequestParametersType = (methodAPIType: MethodAPIType, paramsFirst: [String], paramsSecond: JSON?)

/// API methods.
public enum MethodAPIType {
    /// Displays information about the users specified in the request.
    case getAccounts(names: [String])
    
    /// Displays various information about the current status of the GOLOS network.
    case getDynamicGlobalProperties()
    
    /// Displays a limited number of publications, sorted by type.
    case getDiscussions(type: PostsFeedType, limit: Int)

    
    /// Save `vote` to blockchain
    case verifyAuthorityVote
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> RequestParametersType {
        switch self {
        // GET
        case .getAccounts(let names):                       return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "get_accounts"],
                                                                    paramsSecond:       [names])
            
        case .getDynamicGlobalProperties():                 return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "get_dynamic_global_properties"],
                                                                    paramsSecond:       ["nil"])
            
        case .getDiscussions(let type, let limit):          return (methodAPIType:      self,
                                                                    paramsFirst:        ["social_network", type.caseAPIParameters()],
                                                                    paramsSecond:       ["limit":limit])

            
        // POST
        case .verifyAuthorityVote:                          return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "verify_authority"],
                                                                    paramsSecond:       ["vote"])
            
        }
    }
}
