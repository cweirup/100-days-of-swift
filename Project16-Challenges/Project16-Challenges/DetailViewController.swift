//
//  DetailViewController.swift
//  Project16-Challenges
//
//  Created by Christopher Weirup on 2019-04-25.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var capital: Capital?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let capital = capital else { return }
        
        // Load the Wikipedia page
        
        let urlString = "https://en.wikipedia.org/wiki/" + capital.wikiEntry
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
