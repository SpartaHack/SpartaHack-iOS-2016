//
//  MentorshipViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/16/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class MentorshipViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitTicketButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var scrollViewContentInset: UIEdgeInsets = .zero
    
    var placeHolderText = "Describe your problem. An example would be: \"Help! I can't figure out which awesome animation library to use for my web app!\""
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.descriptionTextView.textColor = Theme.primaryColor
        
        if(self.descriptionTextView.text == placeHolderText) {
            self.descriptionTextView.text = ""
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            self.descriptionTextView.text = placeHolderText
            self.descriptionTextView.textColor = Theme.tintColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        self.hideKeyboard()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        descriptionTextView.delegate = self
        UIView.animate(withDuration: 1.0, animations: {
            self.view.backgroundColor = Theme.backgroundColor
            self.contentView.backgroundColor = Theme.backgroundColor
            self.scrollView.backgroundColor = Theme.backgroundColor
            
            self.categoryTextField.attributedPlaceholder = NSAttributedString(string: "Category",
                                                                              attributes: [NSForegroundColorAttributeName: Theme.tintColor])
            self.categoryTextField.backgroundColor = Theme.backgroundColor
            self.categoryTextField.textColor = Theme.primaryColor
            self.categoryTextField.layer.cornerRadius = 0.0;
            self.categoryTextField.layer.borderColor = Theme.tintColor.cgColor
            self.categoryTextField.layer.borderWidth = 1.5
            
            self.locationTextField.attributedPlaceholder = NSAttributedString(string: "Location",
                                                                              attributes: [NSForegroundColorAttributeName: Theme.tintColor])
            self.locationTextField.backgroundColor = Theme.backgroundColor
            self.locationTextField.textColor = Theme.primaryColor
            self.locationTextField.layer.cornerRadius = 0.0;
            self.locationTextField.layer.borderColor = Theme.tintColor.cgColor
            self.locationTextField.layer.borderWidth = 1.5
            
            self.descriptionTextView.backgroundColor = Theme.backgroundColor
            self.descriptionTextView.textColor = Theme.tintColor // Manually set the textColor to placeholder
            self.descriptionTextView.layer.cornerRadius = 0.0;
            self.descriptionTextView.layer.borderColor = Theme.tintColor.cgColor
            self.descriptionTextView.layer.borderWidth = 1.5
            
            let loginButtonAttributedTitle = NSAttributedString(string: "Submit Ticket",
                                                                attributes: [NSForegroundColorAttributeName : Theme.primaryColor])
            self.submitTicketButton.setAttributedTitle(loginButtonAttributedTitle, for: .normal)
            self.submitTicketButton.layer.cornerRadius = 0.0;
            self.submitTicketButton.layer.borderColor = Theme.tintColor.cgColor
            self.submitTicketButton.layer.borderWidth = 1.5
        })

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification:NSNotification) {
        scrollViewContentInset = self.scrollView.contentInset // save the current content inset to use on keyboardWillHide
        // (We need to save the original content inset because our custom navigation bar already set it
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.scrollView.contentInset = scrollViewContentInset
    }
    
    func requiresLogin() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
