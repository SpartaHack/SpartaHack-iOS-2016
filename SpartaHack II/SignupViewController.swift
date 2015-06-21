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
    @IBOutlet weak var BirthdayTextField: UITextField!
    @IBOutlet weak var NumberOfHackathonsTextField: UITextField!
    @IBOutlet weak var SchoolTextField: UITextField!
    
    @IBOutlet weak var TShritSizeSegment: UISegmentedControl!
    @IBOutlet weak var GenderSegment: UISegmentedControl!
    @IBOutlet weak var FoodSegment: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func SubmitButtonTapped(sender: AnyObject) {
        // perform field validations
        println("Valdate the shit out of the form")
        var test = checkThatFieldsAreFilled()
        var passwordTest = checkPasswordMatch()

        if test != true {
            let alert = UIAlertView(title: "Error", message: "Fields are missing", delegate: self, cancelButtonTitle: "Oh, okay")
            alert.show()
        }
        
        if passwordTest != true {
            let alert = UIAlertView(title: "Error", message: "Passwords don't match", delegate: self, cancelButtonTitle: "Oh, okay")
            alert.show()
            PasswordTextField.text = ""
            PasswordConfirmTextField.text = ""
        }
        
        if test && passwordTest != false {
            // give parse information
            var user = PFUser()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "mm-dd-yyyy"
            
            user.username = EmailAddressLabel.text
            user.password = PasswordTextField.text
            user.email = EmailAddressLabel.text
            user["firstName"] = FirstNameTextField.text
            user["lastName"] = LastNameTextField.text
            user["birthday"] = dateFormatter.dateFromString(BirthdayTextField.text)
            user["numberOfHackathon"] = NumberOfHackathonsTextField.text
            user["school"] = SchoolTextField.text
            
            
            user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    println("error")
                } else {
                    // Hooray! Let them use the app now.
                    println("great success!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
        }
    
    }
    
    func checkThatFieldsAreFilled () -> Bool{
        let arrayOfFields = [FirstNameTextField,LastNameTextField,EmailAddressLabel,PasswordTextField,PasswordConfirmTextField,BirthdayTextField,NumberOfHackathonsTextField,SchoolTextField]
        for thing in arrayOfFields {
            if thing.text.isEmpty == true{
                // error
                println("error")
                return false
            }
        }
        println("success")
        return true
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
