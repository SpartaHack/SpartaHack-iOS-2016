//
//  MentorFormCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/6/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import Foundation

class MentorFormCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var submitTicketButton: UIButton!
    
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
    
    override func layoutSubviews() {
        // ToDo: Get the form to submit to the API
        descriptionTextView.delegate = self
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
            
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
}
