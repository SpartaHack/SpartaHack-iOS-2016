//
//  MapViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIWebViewDelegate {
    
    let pdfView = MapView.loadFromNibNamed(nibNamed: "MapWebView")! as! MapView
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        self.view = pdfView
        pdfView.webView.delegate = self
        
		if let pdf = URL(string: "https://d.api.spartahack.com/map")  {
			let req = URLRequest(url: pdf)
			pdfView.webView.loadRequest(req)
		}
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if let pdf = Bundle.main.url(forResource: "map", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = URLRequest(url: pdf)
            webView.loadRequest(req)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
