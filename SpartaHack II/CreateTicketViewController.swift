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
    
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var platformTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        platformOptions = (NSKeyedUnarchiver.unarchiveObjectWithData(listOfOptions) as? [String])!
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        platformTextField.inputView = pickerView
        
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
        topicLabel.text = topic
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSubmitTicket(success: Bool) {
        if success {
            self.dismissViewControllerAnimated(true, completion:nil)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.descriptionTextField.text = ""
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
