//
//  MapViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIWebViewDelegate {
	@IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        // TODO: Set up the PDF viewer to work with laste year's map
        
		// Do any additional setup after loading the view.
//        webView.delegate = self
//        
//		if let pdf = URL(string: "https://spartahack.com/map")  {
//			let req = URLRequest(url: pdf)
//			webView.loadRequest(req)
//		}
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
