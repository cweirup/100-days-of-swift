//
//  ViewController.swift
//  Consolidation6
//
//  Created by Weirup, Chris on 2019-04-20.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UITableViewController {

    var countries = [Country]()
    var flagCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString = "https://restcountries.eu/rest/v2/all?fields=name;alpha3Code;region;capital;population;alpha2Code"
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
        
        if let jsonCountries = try? decoder.decode([Country].self, from: json) {
            countries = jsonCountries
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        cell.imageView?.image = UIImage(named: "placeholder")
        
        if let imageFromCache = flagCache.object(forKey: country.name as NSString) {
            cell.imageView?.image = imageFromCache
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlString = "https://www.countryflags.io/\(country.alpha2Code)/flat/32.png"
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        // We are okay to parse
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: data)
                            self.flagCache.setObject(UIImage(data: data)!, forKey: country.name as NSString)
                        }
                    }
                }
            }
        }
        cell.textLabel?.text = country.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.selectedCountry = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

