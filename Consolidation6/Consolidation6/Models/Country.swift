//
//  Country.swift
//  Consolidation6
//
//  Created by Weirup, Chris on 2019-04-20.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import Foundation
import UIKit

struct Country: Codable {
    var name: String
    var alpha3Code: String
    var region: String
    var capital: String
    var population: Int
    var alpha2Code: String
    
    var arrayRepresentation: [String] {
        return [
            name,
            alpha3Code,
            region,
            capital,
            Country.formatStringNumber(population)
        ]
    }
}

extension Country {
    static func formatStringNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}
