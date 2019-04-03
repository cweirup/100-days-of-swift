//
//  ViewController.swift
//  Consolidation3
//
//  Created by Weirup, Chris on 2019-04-02.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(captureItem))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        
        navigationItem.rightBarButtonItems = [addButton, shareButton]
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(captureItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearItems))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        // Set the cell text
        cell.textLabel?.text = shoppingList[indexPath.row]
        // Return the cell
        return cell
    }
    
    @objc func captureItem() {
        // Code to add items to our shopping list
        let ac = UIAlertController(title: "Add item", message: "Add item to your shopping list.", preferredStyle: .alert)
        ac.addTextField()
        
        let submitItem = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.addItem(answer)
        }
        
        ac.addAction(submitItem)
        present(ac, animated: true)
    }
    
    func addItem(_ item: String) {
        // Add to shopping list
        shoppingList.insert(item, at: 0)
        
        // Add to the Table View
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func clearItems() {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func shareList() {
        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?[0]
        present(vc, animated: true)
    }
}

