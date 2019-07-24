//
//  ViewController.swift
//  Project10
//
//  Created by Christopher Weirup on 2019-04-09.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

// Load app
// Authenticate
// Load Images from Keychain
// When locked, save images to Keychain
// Clear the collection view and reload

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    var addButton: UIBarButtonItem!
    var lockButton: UIBarButtonItem!
    var unlockButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        lockButton = UIBarButtonItem(title: "Lock", style: .plain, target: self, action: #selector(lock))
        unlockButton = UIBarButtonItem(title: "Unlock", style: .plain, target: self, action: #selector(authenticate))
        
        navigationItem.leftBarButtonItem = unlockButton
        navigationItem.rightBarButtonItem = nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue a PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        
        // Challenge 2 - Allow use of the camera if availabe
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
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        // Challenge 1 - Add second UIAlertController to ask if want to delete or rename person
        let ac = UIAlertController(title: "Rename or Delete", message: "Would you like to rename or delete this person?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self, weak ac] _ in
            let ac2 = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            ac2.addTextField(configurationHandler: { (textField) in
                textField.text = person.name
            })
            
            ac2.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac2] _ in
                guard let newName = ac2?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            
            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac2, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self, weak ac] _ in
            let ac2 = UIAlertController(title: "Delete Person", message: nil, preferredStyle: .alert)
            
            ac2.addAction(UIAlertAction(title: "CONFIRM", style: .destructive) { [weak self, weak ac2] _ in
                self?.people.remove(at: indexPath.item)
                self?.collectionView.reloadData()
            })
            
            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac2, animated: true)
        })
        
        present(ac, animated: true)
    }
    
    @objc func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.loadPeople()
                        self?.collectionView.reloadData()
                        self?.navigationItem.leftBarButtonItem = self?.lockButton
                        self?.navigationItem.rightBarButtonItem = self?.addButton
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
        }
    }
    
    func loadPeople() {
        if let savedPeople = KeychainWrapper.standard.data(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }
    
    func savePeople() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let saveSuccessful = KeychainWrapper.standard.set(savedData, forKey: "people")
            
            if !saveSuccessful {
                print("Failed to save people.")
            }
        } else {
            print("Failed to save people.")
        }
    }

    @objc func lock() {
        savePeople()
        people.removeAll(keepingCapacity: true)
        collectionView.reloadData()
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = unlockButton
        
    }
}

