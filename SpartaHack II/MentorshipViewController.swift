//
//  MentorshipViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/16/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class MentorshipViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitTicketButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var scrollViewContentInset: UIEdgeInsets = .zero
    
    private var lastKnownTheme: Int = -1 // set to -1 so the view loads the theme the first time
    
    var hardcodedCategories = ["iOS", "Swift", "Objective-C", "Not C#", "Not Java"] // bad practice
    
    var placeHolderText = "Describe your problem. An example would be: \"Help! I can't figure out which awesome animation library to use for my web app!\""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needsThemeUpdate() {
            self.updateTheme(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.delegate = self
        locationTextField.delegate = self
        descriptionTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboard()
        
        var pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        categoryTextField.inputView = pickerView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.updateTheme(animated: false)
        
    }
    
    func requiresLogin() -> Bool {
        return true
    }
    
    func needsThemeUpdate() -> Bool {
        return self.lastKnownTheme != Theme.currentTheme()
    }
    
    func updateTheme(animated: Bool = false) {
        self.lastKnownTheme = Theme.currentTheme()
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.setTheme()
            })
        }
        else {
            self.setTheme()
        }
    }
    
    func setTheme() {
        self.view.backgroundColor = Theme.backgroundColor
        self.contentView.backgroundColor = Theme.backgroundColor
        self.scrollView.backgroundColor = Theme.backgroundColor
        
        self.titleLabel.textColor = Theme.primaryColor
        
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    @IBAction func submitButtonTapped(_ sender: AnyObject) {
        if let descriptionString = descriptionTextView.text, let locationString = locationTextField.text, let categoryString = categoryTextField.text {
            SpartaModel.sharedInstance.postMentorship(category: categoryString,
                                                      location: locationString,
                                                      description: descriptionString, completionHandler: { (success:Bool) in
                if (success) {
                        SpartaToast.displayToast("Ticket Submitted!")
                }
            })
        }
    }
    
    // MARK PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hardcodedCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hardcodedCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = hardcodedCategories[row]
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
