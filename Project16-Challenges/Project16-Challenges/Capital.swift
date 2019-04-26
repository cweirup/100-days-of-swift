//
//  Capital.swift
//  Project16
//
//  Created by Weirup, Chris on 2019-04-23.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
