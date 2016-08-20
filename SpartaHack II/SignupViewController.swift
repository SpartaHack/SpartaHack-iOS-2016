//
//  SignupViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/20/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import Foundation
import UIKit

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
    
    
    
    func didRegisterUser(_ success: Bool) {
        if success {
            print("AWAY WITH YOU")
        } else {
            print("ERR")
        }
    }
    
    func checkThatFieldsAreFilled () -> Bool {
        let arrayOfFields = [
        FirstNameTextField,
        LastNameTextField,
        EmailAddressLabel,
        PasswordTextField,
        PasswordConfirmTextField,
        BirthdayTextField,
        NumberOfHackathonsTextField,
        SchoolTextField
        ]
        for thing in arrayOfFields {
            if thing?.text!.isEmpty == true{
                // error
                print("error")
                return false
            }
        }
        print("success")
        return true
    }

}

