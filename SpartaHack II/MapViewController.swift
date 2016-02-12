//
//  MapViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
	@IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		if let pdf = NSURL(string: "https://spartahack.com/map")  {
			let req = NSURLRequest(URL: pdf)
			webView.loadRequest(req)
		}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}