//
//  Note.swift
//  Consolidation8
//
//  Created by Christopher Weirup on 2019-05-15.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import Foundation

struct Note: Codable {
    var id: String      // Using String representation of UUID for this
    var body: String
    var creationDate: Date
    var updatedDate: Date
    
    static func getFormattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
