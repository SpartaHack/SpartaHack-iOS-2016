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
		if let pdf = NSBundle.mainBundle().URLForResource("ios-map", withExtension: "pdf", subdirectory: nil, localization: nil)  {
			let req = NSURLRequest(URL: pdf)
			webView.loadRequest(req)
		}

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
