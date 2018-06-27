//
//  PostsFeedType.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import Localize_Swift

/// Feed type
public enum PostsFeedType: String {
    case new
    case lenta
    case actual
    case popular
    case promoted
    
    public func caseTitle() -> String {
        switch self {
        case .new:          return "New".localized()
        case .lenta:        return "Lenta".localized()
        case .actual:       return "Actual".localized()
        case .popular:      return "Popular".localized()
        case .promoted:     return "Promoted".localized()
        }
    }
    
    func caseAPIParameters() -> String {
        switch self {
        case .new:          return "get_discussions_by_created"
        case .lenta:        return "get_discussions_by_blog"
        case .actual:       return "get_discussions_by_hot"
        case .popular:      return "get_discussions_by_trending"
        case .promoted:     return "get_discussions_by_promoted"
        }
    }

}
