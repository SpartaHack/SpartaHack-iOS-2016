//
//  CreateTicketViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 1/10/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class CreateTicketViewController: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var topic = ""
    var topicObjId = ""
    var listOfOptions = Data()
    var platformOptions:[String] = []
    let pickerView = UIPickerView()
    
    @IBOutlet weak var platformTextField: SpartaTextField!
    @IBOutlet weak var subjectTextField: SpartaTextField!
    @IBOutlet weak var locationTextField: SpartaTextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var createNewTicketButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        platformOptions = (NSKeyedUnarchiver.unarchiveObject(with: listOfOptions) as? [String])!
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTicketViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTicketViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        pickerView.delegate = self
        platformTextField.inputView = pickerView
        
        self.descriptionTextField.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return platformOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return platformOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        platformTextField.text = platformOptions[row]
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.platformTextField.attributedPlaceholder = NSAttributedString(string:"Platform", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        self.subjectTextField.attributedPlaceholder = NSAttributedString(string:"Subject", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        self.locationTextField.attributedPlaceholder = NSAttributedString(string:"Location", attributes:[NSForegroundColorAttributeName: UIColor.spartaGreen()])
        
        self.descriptionTextField.backgroundColor = UIColor.spartaBlack()
        self.descriptionTextField.textColor = UIColor.spartaGreen()
        self.descriptionTextField.layer.borderColor = UIColor.spartaGreen().cgColor
        self.descriptionTextField.layer.cornerRadius = 4
        self.descriptionTextField.layer.borderWidth = 1
        
        self.createNewTicketButton.backgroundColor = UIColor.spartaBlack()
        self.createNewTicketButton.tintColor = UIColor.spartaGreen()
        self.createNewTicketButton.layer.borderColor = UIColor.spartaGreen().cgColor
        self.createNewTicketButton.layer.cornerRadius = 4
        self.createNewTicketButton.layer.borderWidth = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSubmitTicket(_ success: Bool) {
        if success {
//            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.descriptionTextField.text = ""
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
//        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func submitButtonTapped(_ sender: AnyObject) {
    
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
        
    }
    
    func fieldError () {
        let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok.", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
