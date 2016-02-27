//
//  CreateTicketViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 1/10/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class CreateTicketViewController: UIViewController, ParseTicketDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var topic = ""
    var topicObjId = ""
    var listOfOptions = NSData()
    var platformOptions:[String] = []
    let pickerView = UIPickerView()
    
    @IBOutlet weak var platformTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextFieldLimit!
    @IBOutlet weak var locationTextField: UITextFieldLimit!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var createNewTicketButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        platformOptions = (NSKeyedUnarchiver.unarchiveObjectWithData(listOfOptions) as? [String])!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        pickerView.delegate = self
        platformTextField.inputView = pickerView
        
        subjectTextField.limit = 60
        locationTextField.limit = 10
        
        ParseModel.sharedInstance.ticketDelegate = self
        self.descriptionTextField.delegate = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return platformOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return platformOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        platformTextField.text = platformOptions[row]
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.platformTextField.backgroundColor = UIColor.spartaBlack()
        self.platformTextField.textColor = UIColor.whiteColor()
        self.platformTextField.attributedPlaceholder = NSAttributedString(string:"Platform", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        self.platformTextField.textColor = UIColor.spartaGreen()
        self.platformTextField.layer.borderColor = UIColor.spartaGreen().CGColor
        self.platformTextField.layer.cornerRadius = 4
        self.platformTextField.layer.borderWidth = 1
        
        self.subjectTextField.backgroundColor = UIColor.spartaBlack()
        self.subjectTextField.textColor = UIColor.whiteColor()
        self.subjectTextField.attributedPlaceholder = NSAttributedString(string:"Subject", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        self.subjectTextField.textColor = UIColor.spartaGreen()
        self.subjectTextField.layer.borderColor = UIColor.spartaGreen().CGColor
        self.subjectTextField.layer.cornerRadius = 4
        self.subjectTextField.layer.borderWidth = 1
        
        self.locationTextField.backgroundColor = UIColor.spartaBlack()
        self.locationTextField.textColor = UIColor.whiteColor()
        self.locationTextField.attributedPlaceholder = NSAttributedString(string:"Location", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        self.locationTextField.textColor = UIColor.spartaGreen()
        self.locationTextField.layer.borderColor = UIColor.spartaGreen().CGColor
        self.locationTextField.layer.cornerRadius = 4
        self.locationTextField.layer.borderWidth = 1
        
        self.descriptionTextField.backgroundColor = UIColor.spartaBlack()
        self.descriptionTextField.textColor = UIColor.spartaGreen()
        self.descriptionTextField.layer.borderColor = UIColor.spartaGreen().CGColor
        self.descriptionTextField.layer.cornerRadius = 4
        self.descriptionTextField.layer.borderWidth = 1
        
        self.createNewTicketButton.backgroundColor = UIColor.spartaBlack()
        self.createNewTicketButton.tintColor = UIColor.spartaGreen()
        self.createNewTicketButton.layer.borderColor = UIColor.spartaGreen().CGColor
        self.createNewTicketButton.layer.cornerRadius = 4
        self.createNewTicketButton.layer.borderWidth = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSubmitTicket(success: Bool) {
        if success {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.descriptionTextField.text = ""
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func submitButtonTapped(sender: AnyObject) {
    
        guard subjectTextField.text != "" else {
            self.fieldError()
            return
        }
        
        guard locationTextField.text != "" else {
            self.fieldError()
            return
        }
        
        guard descriptionTextField.text != "" else {
            self.fieldError()
            return
        }
        
        guard platformTextField.text != "" else {
            self.fieldError()
            return
        }
        
        ParseModel.sharedInstance.submitUserTicket(topicObjId,
                subject: subjectTextField.text!,
            description: descriptionTextField.text!,
               location: locationTextField.text!,
            subCategory: platformTextField.text!)
    }
    
    func fieldError () {
        let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok.", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }

}
