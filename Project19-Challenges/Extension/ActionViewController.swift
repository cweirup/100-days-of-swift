//
//  ActionViewController.swift
//  Extension
//
//  Created by Christopher Weirup on 2019-05-06.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit
import MobileCoreServices

struct PageScript {
    var url: URL
    var scriptName: String
    var script: String
}

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!

    var pageTitle = ""
    var pageURL = ""
    
    var savedScripts: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveScript))
        navigationItem.rightBarButtonItems = [doneButton, saveButton]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectScript))
        
        // Load in the saved scripts
        let defaults = UserDefaults.standard
        savedScripts = defaults.dictionary(forKey: "SavedScripts") as? [String: String] ?? [:]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    //print(savedScripts)
                    // Load any saved script
                    let url = URL(string: self!.pageURL)
                    var script: String
                    if let host = url?.host {
                        script = self?.savedScripts[host] ?? ""
                        print(script)
                    } else {
                        script = ""
                    }
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.script.text = script
                    }
                }
            }
        }
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
        
        // Save the script for the host
        let url = URL(string: pageURL)
        // Add current script to the dictionary
        if let host = url?.host! {
            savedScripts[host] = script.text
            print(savedScripts[host])
        }
        let defaults = UserDefaults.standard
        defaults.set(savedScripts, forKey: "SavedScripts")
    }
    
    @objc func selectScript() {
        let ac = UIAlertController(title: "Select Script", message: "Select a script to run", preferredStyle: .alert)
        // Add actions
        ac.addAction(UIAlertAction(title: "Display Page Title", style: .default, handler: runScript))
        ac.addAction(UIAlertAction(title: "Display Host Name", style: .default, handler: runScript))
        ac.addAction(UIAlertAction(title: "Display Hello", style: .default, handler: runScript))
        present(ac, animated: true)
    }
    
    func runScript(action: UIAlertAction) {
        var script: String
        switch action.title {
        case "Display Page Title":
            script = "alert(document.title)"
        case "Display Host Name":
            script = "alert(document.URL)"
        default:
            script = "alert('Hello.')"
        }
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func saveScript() {
        guard let url = URL(string: pageURL) else { return }
        
        // Pop up array controller to add name to script
        
        // Add current script to the array
        if let host = url.host {
            savedScripts.updateValue(script.text, forKey: host)
        }
        
        //savedScripts.append(PageScript(url: url, scriptName: "Test name", script: script.text ?? ""))
        
        let defaults = UserDefaults.standard
        defaults.set(savedScripts, forKey: "SavedScripts")
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
