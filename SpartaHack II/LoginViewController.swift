//
//  File.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/27/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func userSuccessfullyLoggedIn (_ result: Bool)
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var formView: UIView!

    var delegate: LoginViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        
        passwordTextField.isSecureTextEntry = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.hideKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = Theme.backgroundColor
        formView.backgroundColor = Theme.backgroundColor
        titleLabel.textColor = Theme.primaryColor
        subtitleLabel.textColor = Theme.primaryColor
        emailTextField.backgroundColor = Theme.backgroundColor
        emailTextField.layer.borderColor = Theme.tintColor.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: Theme.primaryColor])
        emailTextField.textColor = Theme.primaryColor
        passwordTextField.backgroundColor = Theme.backgroundColor
        passwordTextField.layer.borderColor = Theme.tintColor.cgColor
        passwordTextField.textColor = Theme.primaryColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: Theme.primaryColor])

        let loginButtonAttributedTitle = NSAttributedString(string: "Log in",
                                                         attributes: [NSForegroundColorAttributeName : Theme.primaryColor])
        loginButton.setAttributedTitle(loginButtonAttributedTitle, for: .normal)
        loginButton.layer.cornerRadius = 0.0;
        loginButton.layer.borderColor = Theme.tintColor.cgColor
        loginButton.layer.borderWidth = 1.5
        
        let font = UIFont.systemFont(ofSize: 40)

        let closeButtonAttributedTitle = NSAttributedString(string: "x",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor,
                                                                         NSFontAttributeName: font])
        closeButton.setAttributedTitle(closeButtonAttributedTitle, for: .normal)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func userDidLogin(_ login: Bool, error: NSError?) {
        if !login {
            // there was a problem with logging the user in
//            let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
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

    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        if let emailString = emailTextField.text, let passwordString = passwordTextField.text {
            SpartaModel.sharedInstance.getUserSession(email: emailString, password: passwordString, completionHandler: {_ in
                if let navBar = UIApplication.topViewController()?.navigationController?.navigationBar as? SpartaNavigationBar {
                    if let firstName = UserManager.sharedInstance.getFirstName() {
                        navBar.setName(to: firstName)
                    }
                }
                self.userDidLogin(true, error: nil)
            })
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }

    func keyboardWillShow(_ notification:Notification){

//        var userInfo = (notification as NSNotification).userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset:UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        self.scrollView.contentInset = contentInset
    }

    func keyboardWillHide(_ notification:Notification){

//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        self.scrollView.contentInset = contentInset
    }

}
