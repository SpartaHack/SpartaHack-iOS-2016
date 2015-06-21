//
//  SignupViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/20/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // all the labels and buttons here.... there's a lot
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailAddressLabel: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var PasswordConfirmTextField: UITextField!
    @IBOutlet weak var NumberOfHackathonsTextField: UITextField!
    @IBOutlet weak var SchoolTextField: UITextField!
    
    @IBOutlet weak var TShritSizeSegment: UISegmentedControl!
    @IBOutlet weak var GenderSegment: UISegmentedControl!
    @IBOutlet weak var FoodSegment: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func SubmitButtonTapped(sender: AnyObject) {
        // perform field validations
        println("Valdate the shit out of the form")
    
    }
    
    func checkPasswordMatch () -> Bool {
        // this function checks to make sure both password fields match
        if PasswordTextField.text == PasswordConfirmTextField.text {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view code here
        registerForKeyboardNotifications()
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    // MARK: Keyboard Delegates 
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}
