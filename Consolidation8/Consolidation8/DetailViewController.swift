//
//  DetailViewController.swift
//  Consolidation8
//
//  Created by Christopher Weirup on 2019-05-15.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        // Add navigation items -
        // Left - Delete & Compose
        // Right - Share
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [delete, spacer, compose]
        navigationController?.isToolbarHidden = false
        
        textView.text = note.body
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("Did we hit here when leaving?")
        
        note.body = textView.text
        note.updatedDate = Date()
        
        let newNote = Note(title: note.title, body: textView.text, creationDate: note.creationDate, updatedDate: Date())
        
        // Save the note
        let encoder = JSONEncoder()
        print(newNote.body)
        if let encoded = try? encoder.encode(newNote) {
            UserDefaults.standard.set(encoded, forKey: newNote.title)
        }
    }
    
//    func save() {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(note) {
//            UserDefaults.standard.set(encoded, forKey: note.title)
//        }
//    }
    
    @objc func shareTapped() {
        // Get the note details and then provide the share sheet
        let vc = UIActivityViewController(activityItems: [note.body], applicationActivities: [])
        // Needed for iPad, to show where the popover is called from
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func addNote() {
        // Save any changes to current note to the stored array
        
        // Add a new note to array and load into this controller
    }
    
    @objc func deleteNote() {
        // Delete this note from the controller and the array
        
        // return to the main controller
    }
    
    @objc func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(note) {
            UserDefaults.standard.set(encoded, forKey: note.title)
        }
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
