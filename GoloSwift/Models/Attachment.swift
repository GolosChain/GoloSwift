//
//  Attachment.swift
//  Golos
//
//  Created by msm72 on 01.08.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

public enum AttachmentType {
    case link
    case image
}

public struct Attachment {
    // MARK: - Properties
    public let key: String
    public let range: NSRange
    public let value: String
    public let type: AttachmentType
    
    
    // MARK: - Class Initialization
    public init(key: String, range: NSRange, value: String, type: AttachmentType) {
        self.key        =   key
        self.range      =   range
        self.value      =   value
        self.type       =   type
    }
}
