//
//  UIButtonExtension.swift
//  Project2-Day58 Challenge
//
//  Created by Weirup, Chris on 2019-04-20.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

extension UIButton {
    
    func flashButtonDown() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    func flashButtonUp() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [],
            animations: {
                self.transform = .identity
        })
    }
}
