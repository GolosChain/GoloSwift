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
    case getDiscussions(type: PostsFeedType, limit: UInt, selectTags: [String]?, filterTags: [String]?, selectLanguages: [String]?, filterLanguages: [String]?, truncateBody: UInt?, selectAuthors: [String]?, startAuthor: String?, startPerlink: String?, parentAuthor: String?, parentPerlink: String?)
    
    
    
    
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
            
        case .getDiscussions(let type,
                            let limit,
                            let selectTags,
                            let filterTags,
                            let selectLanguages,
                            let filterLanguages,
                            let truncateBody,
                            let selectAuthors,
                            let startAuthor,
                            let startPerlink,
                            let parentAuthor,
                            let parentPerlink):
            // {"id":72,"method":"call","jsonrpc":"2.0","params":["tags","get_discussions_by_hot",[{"limit":20,"truncate_body":1024,"filter_tags":["test","bm-open","bm-ceh23","bm-tasks","bm-taskceh1"]}]]}
            var parametersBody: [String:Any]            =   ["limit":limit]
            
            let truncate_body: UInt                     =   truncateBody ?? 1024
            parametersBody["truncate_body"]             =   truncate_body
            
            if let select_tags = selectTags {
                parametersBody["select_tags"]           =   select_tags
            }
            
            if let filter_tags = filterTags {
                parametersBody["filter_tags"]           =   filter_tags
            }
            
            if let select_languages = selectLanguages {
                parametersBody["select_languages"]      =   select_languages
            }

            if let filter_languages = filterLanguages {
                parametersBody["filter_languages"]      =   filter_languages
            }
            
            if let select_authors = selectAuthors {
                parametersBody["select_authors"]        =   select_authors
            }
            
            if let start_author = startAuthor {
                parametersBody["start_author"]          =   start_author
            }
            
            if let start_perlink = startPerlink {
                parametersBody["start_perlink"]         =   start_perlink
            }
            
            if let parent_perlink = parentPerlink {
                parametersBody["parent_perlink"]        =   parent_perlink
            }
            
            if let parent_author = parentAuthor {
                parametersBody["parent_author"]         =   parent_author
            }
            
            return (methodAPIType:      self,
                    paramsFirst:        ["tags", type.caseAPIParameters()],
                    paramsSecond:       [parametersBody])

            
        // POST
        case .verifyAuthorityVote:                          return (methodAPIType:      self,
                                                                    paramsFirst:        ["database_api", "verify_authority"],
                                                                    paramsSecond:       ["vote"])
            
        }
    }
}
