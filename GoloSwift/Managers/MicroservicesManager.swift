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
    public class func startSession(forCurrentUser userNickName: String, completion: @escaping (ErrorAPI?) -> Void) {
        _ = KeychainManager.deleteData(forUserNickName: userNickName, withKey: keySecret)
        
        if !WebSocketManager.instanceMicroservices.webSocket.isConnected {
            WebSocketManager.instanceMicroservices.webSocket.connect()
            
            if WebSocketManager.instanceMicroservices.webSocket.delegate == nil {
                WebSocketManager.instanceMicroservices.webSocket.delegate = WebSocketManager.instanceMicroservices
            }
        }
        
        // Handlers
        WebSocketManager.instanceMicroservices.completionIsConnected    =   {
            DispatchQueue.main.async(execute: {
                MicroservicesManager.getSecretKey(completion: { (resultKey, errorAPI) in
                    guard errorAPI == nil else {
                        completion(errorAPI)
                        return
                    }
                    
                    Logger.log(message: "secretKey = \(resultKey!)", event: .debug)
                    _ = KeychainManager.save(data: [keySecret: resultKey!], userNickName: userNickName)
                    
                    // Test API 'auth'
                    MicroservicesManager.auth(voter: userNickName, completion: { errorAPI in
                        Logger.log(message: "errorAPI = \(errorAPI?.localizedDescription ?? "XXX")", event: .debug)
                        completion(errorAPI)
                    })
                })
            })
        }
    }
    
    
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
            completion(nil, ErrorAPI.disableInternetConnection())
        }
    }
    
    
    /// Gate-Service: API 'auth'
    public class func auth(voter: String, completion: @escaping (ErrorAPI?) -> Void) {
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
                Broadcast.shared.executeFakePOST(requestByOperationAPIType:    operationAPIType,
                                                 userNickName:                 voter,
                                                 onResult:                     { responseAPIResult in
                                                    if let error = (responseAPIResult as! ResponseAPIMicroserviceAuthResult).error {
                                                        completion(ErrorAPI.blockchain(message: "Error \(error.code)"))
                                                    }
                                                    
                                                    completion(nil)
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
    
    
    /// Gate-Facade: API `setOptions`
    public class func setBasicOptions(userNickName: String, deviceUDID: String, isDarkTheme: Bool, isFeedShowImages: Bool, completion: @escaping (ErrorAPI?) -> Void) {
        if isNetworkAvailable {
            let microserviceMethodAPIType = MicroserviceMethodAPIType.setBasicOptions(user: userNickName, udid: deviceUDID, darkTheme: isDarkTheme ? 1 : 0, showImages: isFeedShowImages ? 1 : 0)
            
            Broadcast.shared.executeGET(byMicroserviceMethodAPIType: microserviceMethodAPIType,
                                        onResult: { responseAPIResult in
                                            Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                            
                                            if let error = (responseAPIResult as! ResponseAPIMicroserviceAuthResult).error {
                                                completion(ErrorAPI.blockchain(message: "Error \(error.code)"))
                                            }
                                            
                                            completion(nil)
            },
                                        onError: { errorAPI in
                                            Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                            completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(ErrorAPI.disableInternetConnection())
        }
    }
    
    
    /// Gate-Facade: API `getOptions`
    public class func getOptions(type: MicroserviceOperationsType, userNickName: String, deviceUDID: String, completion: @escaping (ResponseAPIMicroserviceGetOptionsResult?, ErrorAPI?) -> Void) {
        if isNetworkAvailable {
            let microserviceMethodAPIType = MicroserviceMethodAPIType.getOptions(type: type, user: userNickName, udid: deviceUDID)
            
            Broadcast.shared.executeGET(byMicroserviceMethodAPIType: microserviceMethodAPIType,
                                        onResult: { responseAPIResult in
                                            if let error = (responseAPIResult as! ResponseAPIMicroserviceGetOptionsResult).error {
                                                completion(nil, ErrorAPI.blockchain(message: "Error \(error.code)"))
                                            }
                                            
                                            completion(responseAPIResult as? ResponseAPIMicroserviceGetOptionsResult, nil)
            },
                                        onError: { errorAPI in
                                            Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                            completion(nil, errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(nil, ErrorAPI.disableInternetConnection())
        }
    }
}
