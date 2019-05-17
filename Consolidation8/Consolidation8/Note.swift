//
//  Note.swift
//  Consolidation8
//
//  Created by Christopher Weirup on 2019-05-15.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import Foundation

struct Note: Codable {
    var title: String
    var body: String
    var creationDate: Date
    var updatedDate: Date
}
