//
//  DetailViewController.swift
//  Project7
//
//  Created by Weirup, Chris on 2019-04-03.
//  Copyright © 2019 Christopher Weirup. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        // Challenge 3 - Experiment with the HTML
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 120%; font-family: system-ui, sans-serif; } h1 { font-size: 110%; color: darkblue; } </style>
        </head>
        <body>
        <h1>\(detailItem.title)</h1>
        <article>
        \(detailItem.body)
        </article>
        <p><strong>Signatures:</strong> \(Petition.formatStringNumber(detailItem.signatureCount))</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    

}
