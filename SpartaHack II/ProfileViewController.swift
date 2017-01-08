//
//  ProfileViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/6/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import Foundation

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scanningButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var qrImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = Theme.backgroundColor
        
        self.nameLabel.textColor = Theme.primaryColor
        if let fullNameString = UserManager.sharedInstance.getFullName() {
            self.nameLabel.text = fullNameString
        }
        
        let scanningButtonAttributedTitle = NSAttributedString(string: "Volunteer Scanning",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor])
        self.scanningButton.setAttributedTitle(scanningButtonAttributedTitle, for: .normal)
        self.scanningButton.layer.cornerRadius = 0.0;
        self.scanningButton.layer.borderColor = Theme.tintColor.cgColor
        self.scanningButton.layer.borderWidth = 1.5
        
        let logOutButtonAttributedTitle = NSAttributedString(string: "Log Out",
                                                    attributes: [NSForegroundColorAttributeName : Theme.primaryColor])
        self.logOutButton.setAttributedTitle(logOutButtonAttributedTitle, for: .normal)
        self.logOutButton.layer.cornerRadius = 0.0;
        self.logOutButton.layer.borderColor = Theme.tintColor.cgColor
        self.logOutButton.layer.borderWidth = 1.5

        let font = UIFont.systemFont(ofSize: 40)
        let closeButtonAttributedTitle = NSAttributedString(string: "x",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor,
                                                                         NSFontAttributeName: font])
        self.closeButton.setAttributedTitle(closeButtonAttributedTitle, for: .normal)

    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(_ sender: AnyObject) {
        UserManager.sharedInstance.logOutUser(completionHandler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
