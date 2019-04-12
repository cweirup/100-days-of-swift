//
//  Picture.swift
//  Project1-Day44 Challenge
//
//  Created by Weirup, Chris on 2019-04-10.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class Picture: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
