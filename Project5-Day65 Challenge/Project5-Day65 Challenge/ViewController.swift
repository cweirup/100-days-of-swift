//
//  ViewController.swift
//  Project5
//
//  Created by Christopher Weirup on 2019-03-31.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var currentWord: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        if let loadedWord = defaults.string(forKey: "CurrentWord") {
            currentWord = loadedWord
            title = currentWord
            usedWords = defaults.object(forKey: "UsedWords") as? [String] ?? ["silkworm"]
            tableView.reloadData()
        } else {
            startGame()
        }
    }
    
    @objc func startGame() {
        let defaults = UserDefaults.standard
        
        currentWord = allWords.randomElement()!
        title = currentWord
        defaults.set(currentWord, forKey: "CurrentWord")
        
        usedWords.removeAll(keepingCapacity: true)
        defaults.set(usedWords, forKey: "UsedWords")
        
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }

    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isNotStartWord(word: lowerAnswer) {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        usedWords.insert(answer.lowercased(), at: 0)
                        
                        let defaults = UserDefaults.standard
                        defaults.set(usedWords, forKey: "UsedWords")
                        
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        
                        return
                    } else {
                        showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
                    }
                } else {
                    showErrorMessage(title: "Word already used", message: "Be more original!")
                }
            } else {
                showErrorMessage(title: "Word not possible", message: "You can't spell that work from \(title!.lowercased())")
            }
        } else {
            showErrorMessage(title: "Same as start word", message: "You can't just use \(title!.lowercased())!")
        }

    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        
        if word.utf16.count < 3 { return false }
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isNotStartWord(word: String) -> Bool {
        return word != title?.lowercased()
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

