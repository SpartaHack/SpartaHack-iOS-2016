//
//  LoginViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBAction func SignupButtonTapped(sender: AnyObject) {
        // load the sign up view with the navigation controller segue
        self.performSegueWithIdentifier("signupSegue", sender: nil)
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            println("segue god dammit")
//            self.navigationController?.performSegueWithIdentifier("signupSegue", sender: nil)
//        })
    
    }
    
    @IBAction func LoginButtonTapped(sender: AnyObject) {
    
    
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