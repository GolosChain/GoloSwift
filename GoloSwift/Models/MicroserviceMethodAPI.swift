//
//  MicroserviceMethodAPI.swift
//  AlignedCollectionViewFlowLayout
//
//  Created by msm72 on 12/6/18.
//

import Foundation
import Localize_Swift

/// Type of request parameters
typealias MicroserviceMethodRequestParameters   =   (microserviceMethodAPIType: MicroserviceMethodAPIType, nameAPI: String, parameters: [String])

/// API GET microservices methods
public indirect enum MicroserviceMethodAPIType {
    // Microservices: Gate services
    
    /// Get secret key
    case getSecretKey()
    
    /// Auth
    case auth(user: String, sign: String)
    
    
    // Microservices: Facade services
    case getOptions(user: String, deviceType: String)
    
    /// Set Basic theme options
    case setBasicOptions(user: String, deviceType: String, darkTheme: Int, showImages: Int, soundOn: Int)
    
    /// Set Push options
    case setPushOptions(user: String, deviceType: String, options: RequestParameterAPI.PushOptions)
    
    
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
            
        /// Template { "id":9, "method": "getOptions","jsonrpc": "2.0", "params": { "profile": <userNickName-deviceType> } }
        case .getOptions(let userNickName, let deviceType):
            return  (microserviceMethodAPIType:     self,
                     nameAPI:                       "getOptions",
                     parameters:                    [ String(format: "profile\": \"%@-%@", userNickName, deviceType) ])
            
        /// Template: { "id": 9, "method": "setOptions", "jsonrpc": "2.0", "params": { "profile": <basic-userNickName-deviceUDID>, "basic": { "theme": <Bool> }, "notify: null, "push": null } }
        case .setBasicOptions(let userNickName, let deviceType, let isDarkTheme, let isFeedShowImages, let isSoundOn):
            return  (microserviceMethodAPIType:     self,
                     nameAPI:                       "setOptions",
                     parameters:                    [ String(format: "profile\": \"%@-%@\", \"notify\": null, \"push\": null, \"basic\": [\"lang\": \"%@\", \"theme\": %d, \"feedShowImages\": %d, \"soundOn\": %d]", userNickName, deviceType, Localize.currentLanguage(), isDarkTheme, isFeedShowImages, isSoundOn) ])

        /// Template: { "id": 9, "method": "setOptions", "jsonrpc": "2.0", "params": { "profile": <push-userNickName-deviceUDID>, "basic": null, "notify": null, "push": { "lang": <languageValue>, "show": { "vote": <voteValue>, "flag": <flagValue>, "reply": <replyValue>, "transfer": <transferValue>, "subscribe": <subscribeValue>, "unsubscribe": <unsibscribeValue>, "mention": <mentionValue>, "repost": <repostValue>,  "message": <messageValue>, "witnessVote": <witnessVoteValue>, "witnessCancelVote": <witnessCancelVoteValue>, "reward": <rewardValue>, "curatorReward": <curatorRewardValue> }}}}
        case .setPushOptions(let userNickName, let deviceType, let options):
            return  (microserviceMethodAPIType:     self,
                     nameAPI:                       "setOptions",
                     parameters:                    [ String(format: "profile\": \"%@-%@\", \"basic\": null, \"notify\": null, \"push\": [\"lang\": \"%@\", \"show\": [ %@ ]]", userNickName, deviceType, options.language, options.getOptionsValues()) ])
        } // switch
    }
}
