//
//  Broadcast.swift
//  BlockchainTest
//
//  Created by msm72 on 15.05.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

/// Array of request unique IDs
public var requestIDs               =   [Int]()
/// Type of request API
public typealias RequestAPIType     =   (id: Int, requestMessage: String, startTime: Date, methodAPIType: MethodAPIType)
/// Type of response API
public typealias ResponseAPIType    =   (responseAPI: Decodable?, errorAPI: ErrorAPI?)
/// Type of stored request API
public typealias RequestAPIStore    =   (type: RequestAPIType, completion: (ResponseAPIType) -> Void)

public class Broadcast {
    // MARK: - Properties
    static let shared = Broadcast()
    
    
    // MARK: - Class Initialization
    private init() {}
    
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    /**
     Call any of `GET` API methods.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return `RequestAPIType` tuple.
     
     */
    public func prepareGET(requestByMethodType methodType: MethodAPIType) -> RequestAPIType? {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   methodType.introduced()
        
        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        let requestParams           =   requestParamsType.paramsSecond
        
        do {
            // Encode data
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   try jsonEncoder.encode(requestParams)
            let jsonParamsString    =   "[\(String(data: jsonData, encoding: .utf8)!)]"
            
            jsonData                =   try jsonEncoder.encode(requestAPI)
            var jsonString          =   String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: "]}", with: ",\(jsonParamsString)]}")
            jsonString              =   jsonString
                                            .replacingOccurrences(of: "[[[", with: "[[")
                                            .replacingOccurrences(of: "]]]", with: "]]")
                                            .replacingOccurrences(of: "[\"nil\"]", with: "]")
            Logger.log(message: "\nEncoded JSON -> String:\n\t " + jsonString, event: .debug)
            
            return (id: codeID, requestMessage: jsonString, startTime: Date(), methodAPIType: requestParamsType.methodAPIType)
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return nil
        }
    }
    
    
    /**
     Call any of `GET` API methods.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return `RequestAPIType` tuple.
     
     */
    public func preparePOST(requestByMethodType methodType: MethodAPIType, byTransaction transaction: Transaction) -> String? {
        Logger.log(message: "Success", event: .severe)
        
        let codeID                  =   generateUniqueId()
        let requestParamsType       =   methodType.introduced()
        
        let requestAPI              =   RequestAPI(id:          codeID,
                                                   method:      "call",
                                                   jsonrpc:     "2.0",
                                                   params:      requestParamsType.paramsFirst)
        
        do {
            // Encode: requestAPI + transaction
            let jsonEncoder         =   JSONEncoder()
            var jsonData            =   try jsonEncoder.encode(requestAPI)
            let jsonAPIString       =   "\(String(data: jsonData, encoding: .utf8)!)"
                .replacingOccurrences(of: "]}", with: ",")
            var jsonChainString     =   jsonAPIString
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // ref_block_num
            jsonData                =   try jsonEncoder.encode(["ref_block_num": transaction.ref_block_num])
            var jsonTxString        =   "[\(String(data: jsonData, encoding: .utf8)!)]"
                .replacingOccurrences(of: "}]", with: ",")
            jsonChainString         +=  jsonTxString
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // ref_block_prefix
            jsonData                =   try jsonEncoder.encode(["ref_block_prefix": transaction.ref_block_prefix])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: ",")
            jsonChainString         +=  jsonTxString
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // expiration
            jsonData                =   try jsonEncoder.encode(["expiration": transaction.expiration])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: ",")
            jsonChainString         +=  jsonTxString
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // extensions
            jsonData                =   try jsonEncoder.encode(["extensions": transaction.extensions ?? [String]()])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: ",")
            jsonChainString         +=  jsonTxString
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // signatures
            jsonData                =   try jsonEncoder.encode(["signatures": transaction.signatures])
            jsonTxString            =   "\(String(data: jsonData, encoding: .utf8)!)"
                .replacingOccurrences(of: "{", with: "")
                .replacingOccurrences(of: "}", with: ",\"operations\":[[")
            jsonChainString         +=  jsonTxString
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            // operations
            if  let array = transaction.operations[0] as? [Any],
                let operationArray = array[2] as? [String: Any],
                let operationName = array[0] as? String,
                let operationTypeID = array[1] as? Int {
                // operation name
                jsonChainString     +=  "\"\(operationName)\",{"
//                Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
                
                let keyNames = OperationType.getFieldNames(byTypeID: operationTypeID)
                
                for (i, keyName) in keyNames.enumerated() {
                    let value       =   operationArray.first(where: { $0.key == keyName })!.value
                    
                    // Casting Type
                    if type(of: value) is String.Type {
                        jsonData    =   try jsonEncoder.encode(["\(keyName)": "\(value)"])
                    }
                        
                    else if type(of: value) is Int64.Type {
                        jsonData    =   try jsonEncoder.encode(["\(keyName)": value as! Int64])
                    }
                    
                    jsonTxString    =   "\(String(data: jsonData, encoding: .utf8)!)"
                        .replacingOccurrences(of: "{", with: "")
                    
                    jsonTxString    =   jsonTxString.replacingOccurrences(of: "}", with: (i == keyNames.count - 1) ? "}]]}]]}" : ",")
                    jsonChainString +=  jsonTxString
//                    Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
                }
            }
            
            // Example of request message
            /*
                {"id":1,"method":"call","jsonrpc":"2.0","params":["database_api","verify_authority",
                    [{"ref_block_num":54254,"ref_block_prefix":2067645268,"expiration":"2018-05-14T15:25:30",
                    "operations":[["vote",{"voter":"msm72","author":"yuri-vlad-second","permlink":"sdgsdgsdg234234","weight":10000}]],"extensions":[],
                    "signatures":["1f0541ff3ca57f2d7b1bd7d6c9c5c7c1cbcebe16fd51840826f3670950b5ba90b0743edff772fb29fa8a40665bc19535658fd69831684a30384c0123c13da08be6"]
                    }]
                ]}
             */
            
//            Logger.log(message: "\nEncoded JSON -> jsonChainString:\n\t\(jsonChainString)", event: .debug)
            
            return jsonChainString
        } catch {
            Logger.log(message: "Error: \(error.localizedDescription)", event: .error)
            return nil
        }
    }
    
    
    /**
     Decode blockchain response.
     
     - Parameter jsonData: The `Data` of response.
     - Parameter methodAPIType: The type of API method.
     - Returns: Return `RequestAPIType` tuple.
     
     */
    public func decode(from jsonData: Data, byMethodAPIType methodAPIType: MethodAPIType) throws -> ResponseAPIType {
        do {
            switch methodAPIType {
            // GET
            case .getAccounts(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIUserResult.self, from: jsonData), errorAPI: nil)
                
            case .getDynamicGlobalProperties():
                return (responseAPI: try JSONDecoder().decode(ResponseAPIDynamicGlobalPropertiesResult.self, from: jsonData), errorAPI: nil)
                
            case .getDiscussionsByHot(_), .getDiscussionsByCreated(_), .getDiscussionsByTrending(_), .getDiscussionsByPromoted(_):
                return (responseAPI: try JSONDecoder().decode(ResponseAPIFeedResult.self, from: jsonData), errorAPI: nil)
                
            // POST
            case .verifyAuthorityVote:
                return (responseAPI: try JSONDecoder().decode(ResponseAPIVerifyAuthorityResult.self, from: jsonData), errorAPI: nil)
            }
        } catch {
            Logger.log(message: "\(error)", event: .error)
            return (responseAPI: nil, errorAPI: ErrorAPI.jsonParsingFailure(message: error.localizedDescription))
        }
    }

    
    /// API `get_dynamic_global_properties`
    public func getDynamicGlobalProperties(completion: @escaping (Bool) -> Void) {
        // API `get_dynamic_global_properties`
        let requestAPIType = self.prepareGET(requestByMethodType: .getDynamicGlobalProperties())
        Logger.log(message: "\nrequestAPIType =\n\t\(requestAPIType!)", event: .debug)
        
        // Network Layer (WebSocketManager)
        DispatchQueue.main.async {
            webSocketManager.sendRequest(withType: requestAPIType!) { (responseAPIType) in
                Logger.log(message: "\nresponseAPIType:\n\t\(responseAPIType)", event: .debug)
                
                guard let responseAPI = responseAPIType.responseAPI, let responseAPIResult = responseAPI as? ResponseAPIDynamicGlobalPropertiesResult else {
                    Logger.log(message: responseAPIType.errorAPI!.caseInfo.message, event: .error)
                    completion(false)
                    return
                }
                
                // Get globalProperties (page 5)
                let globalProperties: ResponseAPIDynamicGlobalProperty = responseAPIResult.result
                Logger.log(message: "\nglobalProperties:\n\t\(globalProperties)", event: .debug)
                
                time                =   globalProperties.time.convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
                headBlockID         =   globalProperties.head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
                headBlockNumber     =   UInt16(globalProperties.head_block_number & 0xFFFF)
                
                completion(true)
            }
        }
    }


    /// Generating a unique ID
    private func generateUniqueId() -> Int {
        var generatedID = 0
        
        repeat {
            generatedID = Int(arc4random_uniform(1000))
        } while requestIDs.contains(generatedID)
        
        requestIDs.append(generatedID)
        
        return generatedID
    }
}
