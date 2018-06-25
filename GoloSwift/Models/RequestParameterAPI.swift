//
//  RequestParameterAPI.swift
//  GoloSwift
//
//  Created by msm72 on 01.06.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

public struct RequestParameterAPI {
    public struct Discussion: Encodable {
        // MARK: - Properties
        public let limit: UInt
        public let truncate_body: UInt?
        public let selectTags: [String]?
        public let filterTags: [String]?
        public let selectAuthors: [String]?
        public let selectLanguages: [String]?
        public let filterLanguages: [String]?
        public let start_author: String?
        public let start_permlink: String?
        public let parentAuthor: String?
        public let parentPermlink: String?
        public let vote_limit: UInt?
        
        
        // MARK: - Initialization
        public init(limit: UInt, truncateBody: UInt? = 1024, selectTags: [String]? = nil, filterTags: [String]? = nil, selectAuthors: [String]? = nil, selectLanguages: [String]? = nil, filterLanguages: [String]? = nil, startAuthor: String? = nil, startPermlink: String? = nil, parentAuthor: String? = nil, parentPermlink: String? = nil, voteLimit: UInt? = 0) {
            self.limit              =   limit
            self.truncate_body      =   truncateBody
            self.selectTags         =   selectTags
            self.filterTags         =   filterTags
            self.selectAuthors      =   selectAuthors
            self.selectLanguages    =   selectLanguages
            self.filterLanguages    =   filterLanguages
            self.start_author       =   startAuthor
            self.start_permlink     =   startPermlink
            self.parentAuthor       =   parentAuthor
            self.parentPermlink     =   parentPermlink
            self.vote_limit         =   voteLimit
        }
    }
    
    public struct Comment: Encodable {
        // MARK: - Properties
        public let parentAuthor: String
        public var parentPermlink: String
        public let author: String
        public let title: String
        public let body: String
        public let jsonMetadata: [PostMetadata]

        public var permlink: String {
            set {
                if parentAuthor.isEmpty {
                    self.permlink   =   String(format: "%@-%@-%d", author, title.transliterationInLatin(), Int64(Date().timeIntervalSince1970))
                }
                
                else {
                    self.permlink   =   String(format: "re-%@-%@-%@-%d", parentAuthor, parentPermlink, author, Int64(Date().timeIntervalSince1970))
                }
            }
            
            get {
                return self.permlink
            }
        }

        // MARK: - Initialization
        public init(parentAuthor: String, parentPermlink: String, author: String, title: String, body: String, jsonMetadata: [PostMetadata]) {
            self.parentAuthor       =   parentAuthor
            self.parentPermlink     =   parentPermlink
            self.author             =   author
            self.title              =   title
            self.body               =   body
            self.jsonMetadata       =   jsonMetadata
        }
    }
    
    public struct PostMetadata: Encodable {
        // MARK: - Properties
        public let tags: [String]
        public var app: String      =   "golos.io/0.1"
        public var format: String   =   "markdown"
        
        // MARK: - Initialization
        public init(tags: [String]) {
            self.tags               =   tags
        }
    }
}

