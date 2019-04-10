//
//  ViewController.swift
//  Consolidation4
//
//  Created by Weirup, Chris on 2019-04-07.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var allWords = [String]()
    var currentWord: String!
    var currentAnswer: UITextField!
    var wordLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var usedLetters = [Character]()
    var guessesLabel: UILabel!
    var guesses = 0 {
        didSet {
            guessesLabel.text = "Incorrect Guesses Made: \(guesses)/7"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        // Build the UI
        // - Build the hangman
        // - Build the Answer section
        // - Build the buttons
        // - Build the letters
        
        guessesLabel = UILabel()
        guessesLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLabel.textAlignment = .center
        guessesLabel.text = "Incorrect Guesses Made: 0/7"
        view.addSubview(guessesLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "??????????"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let newGame = UIButton(type: .system)
        newGame.translatesAutoresizingMaskIntoConstraints = false
        newGame.setTitle("New Game", for: .normal)
        newGame.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        view.addSubview(newGame)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            guessesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            guessesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: guessesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            //buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
            newGame.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            newGame.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            newGame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let theLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        var letterCount = 0
        let width = 50
        let height = 40
        
        // Load the letter buttons
        for row in 0..<5 {
            for column in 0..<6  {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                letterButton.setTitle("?", for: .normal)
//                letterButton.layer.borderWidth = 1
//                letterButton.layer.borderColor = UIColor.blue.cgColor
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                //view.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterCount += 1
            }
        }
        
        // Load the letters into the letter button array
        for (index, char) in theLetters.enumerated() {
            letterButtons[index].setTitle(String(char), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load List of Words
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkword"]
        }
        
        startNewGame()
    }

    func startNewGame() {
        // Reset the letter buttons
        for button in letterButtons {
            button.isEnabled = true
        }
        usedLetters.removeAll(keepingCapacity: true)
        
        // Reset the guesses count
        guesses = 0
        
        // Select a random word from the list
        currentWord = allWords.randomElement()
        
        // Convert to an array of Characters?
        
        // Update currentAnswer text field with ? for each letter
        let numberChars = currentWord.count
        var i = 1
        var newEmptyField = ""
        while i <= numberChars {
            newEmptyField = newEmptyField + "?"
            i += 1
        }
        
        currentAnswer.text = newEmptyField
        print(currentWord!)
    }
    
    @objc func newGameTapped(_ sender: UIButton) {
        startNewGame()
        
//        guard let buttonTitle = sender.titleLabel?.text else { return }
//
//        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
//        activatedButtons.append(sender)
//        sender.isHidden = true
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        // Hide the letter button
        // Add the letter to the used letters array
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedLetters.append(Character(buttonTitle))
        sender.isEnabled = false
        
        // Check to see if the letter exists in the word - MAY BE MULTIPLE INSTANCES
        if currentWord.contains(buttonTitle) {
            var newAnswerText = currentAnswer!.text
            for (index, char) in currentWord.enumerated() {
                if char == Character(buttonTitle) {
                    newAnswerText = String(newAnswerText!.prefix(index) + String(char) + newAnswerText!.dropFirst(index + 1))
                    print("\(index): \(char)")
                }
            }
            currentAnswer.text = newAnswerText
            
            // Check to see if they won the game
            if currentAnswer!.text?.contains("?") == false {
                // Wins!
                let ac = UIAlertController(title: "You Won!", message: "You guessed the word and lived! Do you want to play again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: restartGame))
                present(ac, animated: true)
                
                return
            }
        } else {
            addBodyPart()
        }
        // If it does, replace it in the answers label
            // If all letters are unveiled, end the game
        // If it doesn't, add 1 to the guesses count
            // If guesses are at 7, end the game

    }
    
    // Select a random word from the list
    
    func addBodyPart() {
        guesses += 1
        if guesses == 7 {
            // End the game
            let ac = UIAlertController(title: "Game Over!", message: "You have died! The word was \(currentWord!). Do you want to play again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
    }
    
    func restartGame(action: UIAlertAction) {
        startNewGame()
    }

}

