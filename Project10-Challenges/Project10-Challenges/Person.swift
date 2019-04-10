//
//  Person.swift
//  Project10
//
//  Created by Christopher Weirup on 2019-04-09.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
