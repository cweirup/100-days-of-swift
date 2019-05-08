//
//  Target.swift
//  Consolidation7
//
//  Created by Weirup, Chris on 2019-05-02.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

enum TargetType: Int {
    case good = -1
    case bad = 1
    case ugly = 2
}

struct Target {
    var image: UIImage
    var size: Int
    var speed: Double
    var isEnemy: Bool
    var type: TargetType
}
