//
//  Picture.swift
//  Consolidation5
//
//  Created by Weirup, Chris on 2019-04-13.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
