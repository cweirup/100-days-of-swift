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
    var subtitle: String
    var views: Int {
        didSet {
            subtitle = "Views: \(views)"
        }
    }
    
    init(name: String, image: String, subtitle: String, views: Int) {
        self.name = name
        self.image = image
        self.subtitle = subtitle
        self.views = views
    }
}
