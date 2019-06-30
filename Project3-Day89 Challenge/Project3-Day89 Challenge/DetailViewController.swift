//
//  DetailViewController.swift
//  Project1
//
//  Created by Christopher Weirup on 2019-03-27.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalImages: Int?
    var selectedImageNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(selectedImageNumber ?? 0) of \(totalImages ?? 0)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        // Day 89 Challenge - Change the way the selected image is shared
        //      so that it has some rendered text on top saying “From Storm Viewer”
        guard let imageSize = imageView.image?.size else { return }
        
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        guard let imageName = selectedImage else {
            print("No image name found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let newImage = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .right
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 30),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.gray
            ]
            
            let string = "From Storm Viewer"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: imageSize.width - 332, y: imageSize.height - 64, width: 300, height: 32), options: .usesLineFragmentOrigin, context: nil)
        }
        
        let vc = UIActivityViewController(activityItems: [newImage.jpegData(compressionQuality: 0.8) as Any, imageName], applicationActivities: [])
        // Needed for iPad, to show where the popover is called from
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
