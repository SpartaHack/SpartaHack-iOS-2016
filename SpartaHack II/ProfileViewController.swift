//
//  ProfileViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/28/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, LoginViewControllerDelegate {

    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user = PFUser.currentUser()
    var asked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userNameLabel.text = user?.username

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            vc.delegate = self
            if !asked {
                asked = true  
                self.navigationController?.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    func userSuccessfullyLoggedIn(result: Bool) {
        if !result {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        PFUser.logOut()
        print("logged out")
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
