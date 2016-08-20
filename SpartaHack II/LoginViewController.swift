//
//  LoginViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewControllerDelegate {
    func userSuccessfullyLoggedIn (_ result: Bool)
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    var delegate: LoginViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        titleLabel.textColor = UIColor.spartaGreen()
        sloganLabel.textColor = UIColor.spartaGreen()
        
        // fixing overrides
        emailTextField.backgroundColor = UIColor.spartaBlack()
        emailTextField.layer.borderColor = UIColor.spartaMutedGrey().cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        emailTextField.textColor = UIColor.spartaGreen()
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        passwordTextField.backgroundColor = UIColor.spartaBlack()
        passwordTextField.layer.borderColor = UIColor.spartaMutedGrey().cgColor
        passwordTextField.textColor = UIColor.spartaGreen()
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        loginButton.layer.cornerRadius = 1
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.spartaMutedGrey().cgColor
        loginButton.titleLabel?.textColor = UIColor.spartaGreen()
        loginButton.backgroundColor = UIColor.spartaBlack()
        loginButton.titleLabel?.textColor = UIColor.spartaGreen()
        
        nahButton.layer.cornerRadius = 1
        nahButton.layer.borderWidth = 1
        nahButton.layer.borderColor = UIColor.spartaMutedGrey().cgColor
        nahButton.titleLabel?.textColor = UIColor.spartaGreen()
        nahButton.backgroundColor = UIColor.spartaBlack()
        nahButton.titleLabel?.textColor = UIColor.spartaGreen()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func SignupButtonTapped(_ sender: AnyObject) {
        // load the sign up view with the navigation controller segue
        // TODO: make a constants file
        self.performSegue(withIdentifier: "signupSegue", sender: nil)
    }
    

    
    func userDidLogin(_ login: Bool, error: NSError?) {
        if !login {
            // there was a problem with logging the user in
            let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("ERROR")
        } else {
            print("dismissing login view")
            self.dismiss(animated: true, completion: { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.userSuccessfullyLoggedIn(true)
                })
            })
        }
    }
    
    @IBAction func skipLoginButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true) { () -> Void in
            self.delegate?.userSuccessfullyLoggedIn(false)
        }
    }
    
    func keyboardWillShow(_ notification:Notification){
        
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
}
