//
//  ViewController.swift
//  Consolidation8
//
//  Created by Christopher Weirup on 2019-05-15.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var notesCount = 0 {
        didSet {
            if notesCount == 1 { countLabel.text = "\(notesCount) Note" }
            else { countLabel.text = "\(notesCount) Notes" }
        }
    }
    let countLabel = UILabel()
    var notes = [Note]() {
        didSet {
            notesCount = notes.count
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Need to load all Notes from disk in
        let userDefaults = UserDefaults.standard
        
        // FOLLOW-UP: Save to storage versus UserDefaults
        //let notesPath = getDocumentsDirectory().appendingPathComponent("notes.json")
        //let savedNotes = userDefaults.dictionaryRepresentation()
        
        let decoder = JSONDecoder.init()
        do {
            if let notesData = userDefaults.data(forKey: "SavedNotes") {
                notes = try decoder.decode([Note].self, from: notesData)
            }
        } catch {
            print("Failed to load notes")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        countLabel.text = "\(notesCount) Notes"
        countLabel.sizeToFit()
        let count = UIBarButtonItem(customView: countLabel)
        
        toolbarItems = [count, spacer, compose]
        
        // I wasn't able to figure out how to set the Nav Controller Toolbar tint color in IB
        navigationController?.toolbar.tintColor = UIColor(red:0.97, green:0.59, blue:0.27, alpha:1.0)
        
        navigationController?.isToolbarHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].body
        cell.detailTextLabel?.text = Note.getFormattedDate(from: notes[indexPath.row].updatedDate)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? DetailViewController {
            vc.note = notes[indexPath.row]
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func addNote() {
        // Add a new note to array and load into DetailView controller
        let newNote = Note(id: UUID().uuidString, body: "", creationDate: Date(), updatedDate: Date())
        notes.append(newNote)
        save()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? DetailViewController {
            vc.note = newNote
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        // Save array to UserDefaults
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "SavedNotes")
        }
        
        // Update the table
        tableView.reloadData()
    }
    
    func updatedSelectedNote(newNote: Note) {
        // Does the note exist in our array?
        if let note = notes.enumerated().first(where: {$0.element.id == newNote.id}) {
            // YES = Update it in the array
            notes[note.offset].body = newNote.body
            notes[note.offset].updatedDate = newNote.updatedDate
        } else {
            // NO = Add it to our array
            notes.append(newNote)
        }
        
        save()
    }
    
    func deleteNote(id: String) {
        // Delete this note from the controller and the array
        if let note = notes.enumerated().first(where: {$0.element.id == id}) {
            // YES = Update it in the array
            notes.remove(at: note.offset)
        }
        
        save()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

