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
    let key: String
    let range: NSRange
    let value: String
    let type: AttachmentType
}
