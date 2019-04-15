//
//  ViewController.swift
//  Consolidation5
//
//  Created by Weirup, Chris on 2019-04-13.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture Minder"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNew))
        
        // Load images from UserDefaults via Codable
        let defaults = UserDefaults.standard
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].caption
        let imagePath = Directory.getDocumentDirectory().appendingPathComponent(pictures[indexPath.row].image)
        cell.imageView?.image = UIImage(contentsOfFile: imagePath.path)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add DetailViewController info here
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.picture = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func addNew() {
        // Load the camera picker
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = Directory.getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
//        let picture = Picture(image: imagePath.absoluteString, caption: "None")
//        pictures.append(picture)
//        save()
//        tableView.reloadData()
        
        dismiss(animated: true)
        
        // Launch dialog for caption
        let ac = UIAlertController(title: "Enter Caption", message: "Enter a caption for the picture", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let newCaption = ac?.textFields![0].text else { return }
            let picture = Picture(image: imageName, caption: newCaption)
            self?.pictures.append(picture)
            self?.save()
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
        
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            // Save to defaults or somewhere else?
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save picture data.")
        }
    }
}

