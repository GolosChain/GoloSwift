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
        public let startAuthor: String?
        public let startPerlink: String?
        public let parentAuthor: String?
        public let parentPerlink: String?
        
        
        // MARK: - Initialization
        public init(limit: UInt, truncateBody: UInt? = 1024, selectTags: [String]? = nil, filterTags: [String]? = nil, selectAuthors: [String]? = nil, selectLanguages: [String]? = nil, filterLanguages: [String]? = nil, startAuthor: String? = nil, startPerlink: String? = nil, parentAuthor: String? = nil, parentPerlink: String? = nil) {
            self.limit              =   limit
            self.truncate_body      =   truncateBody
            self.selectTags         =   selectTags
            self.filterTags         =   filterTags
            self.selectAuthors      =   selectAuthors
            self.selectLanguages    =   selectLanguages
            self.filterLanguages    =   filterLanguages
            self.startAuthor        =   startAuthor
            self.startPerlink       =   startPerlink
            self.parentAuthor       =   parentAuthor
            self.parentPerlink      =   parentPerlink
        }
    }
}

