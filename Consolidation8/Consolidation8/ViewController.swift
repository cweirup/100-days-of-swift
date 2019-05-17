//
//  ViewController.swift
//  Consolidation8
//
//  Created by Christopher Weirup on 2019-05-15.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Need to load all Notes from disk in
        //let notesPath = getDocumentsDirectory().appendingPathComponent("notes.json")
        let userDefaults = UserDefaults.standard
        let savedNotes = userDefaults.dictionaryRepresentation()
        
        // Cycle through the dictionary to get the notes
        let decoder = JSONDecoder.init()
        for savedNote in savedNotes {
            do {
                if let noteData = userDefaults.data(forKey: savedNote.key) {
                    let note = try decoder.decode(Note.self, from: noteData)
                    notes.append(note)
                }
            } catch {
                print("Failed to load notes")
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Need to load all Notes from disk in
        //let notesPath = getDocumentsDirectory().appendingPathComponent("notes.json")
//        let userDefaults = UserDefaults.standard
//        let savedNotes = userDefaults.dictionaryRepresentation()
//
//        // Cycle through the dictionary to get the notes
//        let decoder = JSONDecoder.init()
//        for savedNote in savedNotes {
//            do {
//                if let noteData = userDefaults.data(forKey: savedNote.key) {
//                    let note = try decoder.decode(Note.self, from: noteData)
//                    notes.append(note)
//                }
//            } catch {
//                print("Failed to load notes")
//            }
//        }
        
        
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addNote))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [delete, spacer, compose]
        navigationController?.isToolbarHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].body
        cell.detailTextLabel?.text = notes[indexPath.row].updatedDate.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? DetailViewController {
            vc.note = notes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func addNote() {
        // Add a new note to array and load into DetailView controller
        let newNote = Note(title: "Note title", body: "Note body", creationDate: Date(), updatedDate: Date())
        save(note: newNote)
        notes.append(newNote)
        //let newIndexPath = IndexPath(row: (notes.count - 1), section: 0)
        //tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        tableView.reloadData()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? DetailViewController {
            vc.note = newNote
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save(note: Note) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(note) {
            UserDefaults.standard.set(encoded, forKey: note.title)
        }
    }
    
    @objc func deleteNote() {
        // Delete this note from the controller and the array
        
        // return to the main controller
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

