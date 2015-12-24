//
//  ConciergeViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 9/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

class ConciergeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if let currentUser = PFUser.currentUser() {
            // Check to see if a user is logged in, if not, show login view
            print(currentUser)
        } else {
            // TODO: make a constants file
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
