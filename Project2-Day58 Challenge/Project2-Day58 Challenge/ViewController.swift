//
//  ViewController.swift
//  Project2
//
//  Created by Weirup, Chris on 2019-03-28.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var score: Int = 0
    var correctAnswer = 0
    var questionsAsked = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(barButtonTapped))
        
        // Load stored high score
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "HighScore")
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        if questionsAsked < 10 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            
            button1.setImage(UIImage(named: countries[0]), for: .normal)
            button2.setImage(UIImage(named: countries[1]), for: .normal)
            button3.setImage(UIImage(named: countries[2]), for: .normal)
            
            title = countries[correctAnswer].uppercased() + " - Score: \(score)"
            questionsAsked += 1
        } else {
            title = "Final Score: \(score)"
            
            // Reset the score & questions asked
            questionsAsked = 0
            score = 0
            correctAnswer = 0
        }
    }
    
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        sender.flashButtonDown()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.flashButtonUp()
        
        var title: String
        var message: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, that is \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if questionsAsked == 10 {
            message = "Your final score is \(score)"
            if score > highScore {
                highScore = score
                
                let defaults = UserDefaults.standard
                defaults.set(highScore, forKey: "HighScore")
                
                message += ", which is a new high score!"
            }
        } else {
            message = "Your score is \(score)"
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    @objc func barButtonTapped() {
        let ac = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }

}

