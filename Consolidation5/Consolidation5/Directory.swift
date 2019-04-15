//
//  Directory.swift
//  Consolidation5
//
//  Created by Weirup, Chris on 2019-04-14.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class Directory: NSObject {

    static func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
