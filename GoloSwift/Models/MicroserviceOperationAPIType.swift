//
//  MicroserviceOperationAPIType.swift
//  GoloSwift
//
//  Created by msm72 on 12/18/18.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

/// Type of request parameters
typealias MicroserviceOperationRequestParameters = (operationAPIType: MicroserviceOperationAPIType, parameters: [Encodable])

/// API POST operations
public indirect enum MicroserviceOperationAPIType {
    // API: POST
    case vote(fields: RequestParameterAPI.Vote)
    
    
    /// This method return request parameters from selected enum case.
    func introduced() -> MicroserviceOperationRequestParameters {
        switch self {
        case .vote(let voteValue):                          return  (operationAPIType:      self,
                                                                     parameters:            [voteValue])
        }
    }
}
