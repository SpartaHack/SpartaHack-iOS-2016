//
//  RootTabBarViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 1/7/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

class RootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.spartaGreen()
        self.tabBar.backgroundColor = UIColor.spartaBlack()
        self.tabBar.barTintColor = UIColor.spartaBlack()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileButtonTapped(sender: AnyObject) {
        if PFUser.currentUser() == nil {
            // load the login view
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
        } else {
            // load the profile
            self.navigationController?.performSegueWithIdentifier("profileSegue", sender: nil)
        }
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
