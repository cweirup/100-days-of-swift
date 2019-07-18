//
//  ViewController.swift
//  Consolidation10
//
//  Created by Christopher Weirup on 2019-07-17.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

enum textPosition {
    case top
    case bottom
}

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var anImage = UIImage()
    var topText = NSAttributedString()
    var bottomText = NSAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportImage))
    }

    @IBAction func importPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        anImage = image
        imageView.image = anImage
    }
    
    @IBAction func setTopText(_ sender: Any) {
        let ac = UIAlertController(title: "Top text", message: "Enter text for the top of the image", preferredStyle: .alert)
        ac.addTextField()
        let setText = UIAlertAction(title: "Set Text", style: .default) {
            [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            self?.setText(text, textPosition.top)
        }
        ac.addAction(setText)
        present(ac, animated: true)
    }
    
    @IBAction func insertBottomText(_ sender: Any) {
        let ac = UIAlertController(title: "Bottom text", message: "Enter text for the bottom of the image", preferredStyle: .alert)
        ac.addTextField()
        let setText = UIAlertAction(title: "Set Text", style: .default) {
            [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            self?.setText(text, textPosition.bottom)
        }
        ac.addAction(setText)
        present(ac, animated: true)
    }
    
    @objc func exportImage() {
        let vc = UIActivityViewController(activityItems: [anImage], applicationActivities: [])
        // Needed for iPad, to show where the popover is called from
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func setText(_ text: String, _ position: textPosition) {
        // Set the string formatting
        let font = UIFont(name: "AvenirNextCondensed-Bold", size: 48)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .strokeWidth: -4.0,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: textAttributes)
        
        // Add it to the appropriate label on the screen
        if position == textPosition.top {
            topLabel.attributedText = attributedString
            topText = attributedString
        } else {
            bottomLabel.attributedText = attributedString
            bottomText = attributedString
        }
        
        // Update the stored image
        let renderer = UIGraphicsImageRenderer(size: containerView.frame.size)
        
        let image = renderer.image { ctx in
            containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: true)
        }
        
        anImage = image
    }
}

