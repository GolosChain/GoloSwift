//
//  MicroservicesManager.swift
//  Golos
//
//  Created by msm72 on 12/18/18.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

public class MicroservicesManager {
    // MARK: - Class Functions
    
    /// Gate-Service: API 'getSecret'
    public class func getSecretKey(completion: @escaping (String?, ErrorAPI?) -> Void) {
        if isNetworkAvailable {
            let microserviceMethodAPIType = MicroserviceMethodAPIType.getSecretKey()
            
            Broadcast.shared.executeGET(byMicroserviceMethodAPIType: microserviceMethodAPIType,
                                        onResult: { responseAPIResult in
                                            Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                            
                                            guard let result = (responseAPIResult as! ResponseAPIMicroserviceSecretResult).result else {
                                                completion(nil, ErrorAPI.requestFailed(message: "User followings are not found"))
                                                return
                                            }
                                            
                                            completion(result.secret, nil)
            },
                                        onError: { errorAPI in
                                            Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                            completion(nil, errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(nil, nil)
        }
    }
    
    /// Gate-Service: API 'auth'
    public class func auth(voter: String, completion: @escaping (ErrorAPI?) -> Void) {
        if isNetworkAvailable {
            if let secretKey = KeychainManager.loadData(forUserNickName: voter, withKey: keySecret)?.values.first as? String {
                let vote    =   RequestParameterAPI.Vote(voter:         voter,
                                                         author:        "test",
                                                         permlink:      secretKey,
                                                         weight:        1)
                
                let operationAPIType = OperationAPIType.voteAuth(fields: vote)
                
                // Run API
                let postRequestQueue = DispatchQueue.global(qos: .background)
                
                // Run queue in Async Thread
                postRequestQueue.async {
                    Broadcast.shared.executePOST(requestByOperationAPIType:    operationAPIType,
                                                 userNickName:                 voter,
                                                 onResult:                     { responseAPIResult in
                                                    var errorAPI: ErrorAPI?
                                                    
                                                    if let error = (responseAPIResult as! ResponseAPIBlockchainPostResult).error {
                                                        errorAPI = ErrorAPI.requestFailed(message: error.message)
                                                    }
                                                    
                                                    completion(errorAPI)
                    },
                                                 onError: { errorAPI in
                                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                                    completion(errorAPI)
                    })
                }
            }
                
            else {
                completion(ErrorAPI.requestFailed(message: "Secret key not found"))
            }
        }
        
        // Offline mode
        else {
            completion(nil, nil)
        }
    }
}
