//
//  ViewController.swift
//  Project7
//
//  Created by Christopher Weirup on 2019-04-03.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        title = "Petitions"
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        // Challenge 1 - Add a Credits Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
        
        //let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        //let urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // We are okay to parse
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Data provided by the We The People API of whitehouse.gov", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Search", message: "Find petitions by search term or empty to reset", preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] action in
            guard let searchTerm = ac?.textFields?[0].text else { return }
            self?.submit(searchTerm)
        }
        
        ac.addAction(searchAction)
        present(ac, animated: true)
    }
    
    func submit(_ searchTerm: String) {
        // Empty out the filteredPetitions
        // Project 9 Challenge 3 - Do this via GCD
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.filteredPetitions.removeAll(keepingCapacity: true)
            
            // Get lowercased version of the search word
            let word = searchTerm.lowercased()
            
            // Look through the array of Structs for the term
            // and copy those entries into filteredPetitions
            if word == "" {
                self?.filteredPetitions = self!.petitions
                self?.title = "Petitions"
            } else {
                for petition in self!.petitions {
                    if petition.title.lowercased().contains(word) || petition.body.lowercased().contains(word) {
                        self?.filteredPetitions.append(petition)
                    }
                }
                self?.title = "Filter: \(word)"
            }
        }
        // Reload the tableView
        // Project 9 Challenge 3 - Do this via GCD
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
}

