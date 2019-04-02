//
//  ViewController.swift
//  Consolidated2
//
//  Created by Christopher Weirup on 2019-03-29.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries: [(name: String, flag: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "World Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path).sorted()
        
        for item in items {
            if item.hasSuffix("@3x.png") {
                let name = item.components(separatedBy: "@")[0].uppercased()
                countries.append((name, item))
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        cell.imageView?.image = UIImage(named: countries[indexPath.row].flag)
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedFlag = countries[indexPath.row].flag
            vc.selectedCountry = countries[indexPath.row].name
            vc.selectedImageNumber = indexPath.row + 1
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

