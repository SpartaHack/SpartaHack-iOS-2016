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

protocol LoginViewControllerDelegate {
    func userSuccessfullyLoggedIn (result: Bool)
}

class LoginViewController: UIViewController, UITextFieldDelegate, ParseUserDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate: LoginViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.userDelegate = self
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
            print("dismissing login view")
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate?.userSuccessfullyLoggedIn(true)
                })
            })
        }
    }
    
    @IBAction func ForgotPasswordButtonTapped(sender: AnyObject) {
    
    
    }
    
    @IBAction func skipLoginButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.userSuccessfullyLoggedIn(false)
        }
    }
}