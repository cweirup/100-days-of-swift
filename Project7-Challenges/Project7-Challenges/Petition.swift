//
//  Petition.swift
//  Project7
//
//  Created by Weirup, Chris on 2019-04-03.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

extension Petition {
    static func formatStringNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}
