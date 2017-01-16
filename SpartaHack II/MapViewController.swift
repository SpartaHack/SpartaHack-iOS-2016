//
//  MapViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIWebViewDelegate {
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        let navBarSize:CGFloat = (self.navigationController?.navigationBar.bounds.size.height)! + 20.0 // size of the nav bar + the status bar
        let tabBarSize:CGFloat = (self.tabBarController?.tabBar.bounds.size.height)!
        
        let webView:UIWebView = UIWebView(frame: CGRect(x: 0,
                                                        y: navBarSize,
                                                    width: UIScreen.main.bounds.width,
                                                   height: UIScreen.main.bounds.height - navBarSize))
        webView.scrollView.contentInset = UIEdgeInsetsMake(-navBarSize, 0, tabBarSize, 0)
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(-navBarSize, 0, tabBarSize, 0)
        
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        
        SpartaModel.sharedInstance.getMap { (url:URL?) in
            if url != nil {
                let req = URLRequest(url: url!)
                webView.loadRequest(req)
            }
        }
        
        self.view.addSubview(webView)
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if let pdf = Bundle.main.url(forResource: "map", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = URLRequest(url: pdf)
            webView.loadRequest(req)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.scrollsToTop = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
