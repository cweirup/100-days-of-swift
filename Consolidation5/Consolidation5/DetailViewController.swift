//
//  DetailViewController.swift
//  Consolidation5
//
//  Created by Weirup, Chris on 2019-04-14.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var picture: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = picture?.caption ?? "Unknown Person"
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = picture?.image {
            print(imageToLoad)
            let imagePath = Directory.getDocumentDirectory().appendingPathComponent(imageToLoad)
            imageView.image = UIImage(contentsOfFile: imagePath.path)
        }
    }

}
