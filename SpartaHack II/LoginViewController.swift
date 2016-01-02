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

class LoginViewController: UIViewController, UITextFieldDelegate, ParseModelDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func SignupButtonTapped(sender: AnyObject) {
        // load the sign up view with the navigation controller segue
        // TODO: make a constants file
        self.performSegueWithIdentifier("signupSegue", sender: nil)
    }
    
    @IBAction func LoginButtonTapped(sender: AnyObject) {
        ParseModel.sharedInstance.loginUser(emailTextField.text!, password: passwordTextField.text!)
    }
    
    func userDidLogin(login: Bool) {
        if !login {
            // there was a problem with logging the user in
            print("ERROR")
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func ForgotPasswordButtonTapped(sender: AnyObject) {
    
    
    }
    
    @IBAction func skipLoginButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}