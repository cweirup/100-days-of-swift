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
    weak var delegate: ViewController!
    var willSaveNote = true
    
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

        if willSaveNote == true { saveNote() }
    }
    
    @objc func shareTapped() {
        // Get the note details and then provide the share sheet
        let vc = UIActivityViewController(activityItems: [note.body], applicationActivities: [])
        // Needed for iPad, to show where the popover is called from
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func saveNote() {
        let newNote = Note(id: note.id, body: textView.text, creationDate: note.creationDate, updatedDate: Date())
        delegate.updatedSelectedNote(newNote: newNote)
    }
    
    @objc func addNote() {
        // Save any changes to current note to the stored array
        saveNote()
        
        // Add a new note to array and load into this controller
        note = Note(id: UUID().uuidString, body: "", creationDate: Date(), updatedDate: Date())
        textView.text = note.body
    }
    
    @objc func deleteNote() {
        delegate.deleteNote(id: note.id)
        
        willSaveNote = false
        
        // Need to return to main ViewController
        navigationController?.popToRootViewController(animated: true)
    }

}
