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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nahButton: UIButton!

    var delegate: LoginViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.userDelegate = self
        
        titleLabel.textColor = UIColor.spartaGreen()
        sloganLabel.textColor = UIColor.spartaGreen()
        
        
        emailTextField.backgroundColor = UIColor.spartaBlack()
        emailTextField.layer.borderColor = UIColor.spartaMutedGrey().CGColor
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        emailTextField.textColor = UIColor.spartaGreen()
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        passwordTextField.backgroundColor = UIColor.spartaBlack()
        passwordTextField.layer.borderColor = UIColor.spartaMutedGrey().CGColor
        passwordTextField.textColor = UIColor.spartaGreen()
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        loginButton.layer.cornerRadius = 1
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.spartaMutedGrey().CGColor
        loginButton.titleLabel?.textColor = UIColor.spartaGreen()
        loginButton.backgroundColor = UIColor.spartaBlack()
        loginButton.titleLabel?.textColor = UIColor.spartaGreen()
        
        nahButton.layer.cornerRadius = 1
        nahButton.layer.borderWidth = 1
        nahButton.layer.borderColor = UIColor.spartaMutedGrey().CGColor
        nahButton.titleLabel?.textColor = UIColor.spartaGreen()
        nahButton.backgroundColor = UIColor.spartaBlack()
        nahButton.titleLabel?.textColor = UIColor.spartaGreen()
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
        ParseModel.sharedInstance.loginUser((emailTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!, password: passwordTextField.text!)
    }
    
    func userDidLogin(login: Bool, error: NSError?) {
        if !login {
            // there was a problem with logging the user in
            let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
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
    
    @IBAction func skipLoginButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.userSuccessfullyLoggedIn(false)
        }
    }
}