//
//  LoginViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func SignupButtonTapped(sender: AnyObject) {
        // load the sign up view with the navigation controller segue
        self.performSegueWithIdentifier("signupSegue", sender: nil)   
    }
    
    @IBAction func LoginButtonTapped(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(emailTextField.text, password:passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    
    @IBAction func ForgotPasswordButtonTapped(sender: AnyObject) {
    
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view code here
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}