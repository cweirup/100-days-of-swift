//
//  DetailViewController.swift
//  Consolidation6
//
//  Created by Weirup, Chris on 2019-04-20.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var selectedCountry: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCountry.name
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedCountry.arrayRepresentation.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        var cellText: String
        
        switch indexPath.row {
            case 0:
                cellText = "Name: "
        case 1:
            cellText = "3 Letter Code: "
        case 2:
            cellText = "Region: "
        case 3:
            cellText = "Captial: "
        case 4:
            cellText = "Population: "
        case 5:
            cellText = "Flag Link: "
        default:
            cellText = "Unknown Field: "
        }
        
        cell.textLabel?.text = cellText + selectedCountry.arrayRepresentation[indexPath.row]
        return cell
    }

}
