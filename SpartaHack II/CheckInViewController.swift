//
//  CheckInViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/15/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import Foundation

protocol CheckInViewControllerDelegate {
    func userCheckedIn (_ result: Bool)
}

class CheckInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate: CheckInViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = Theme.backgroundColor
        
        let scanButtonAttributedTitle = NSAttributedString(string: "Scan",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor])
        scanButton.setAttributedTitle(scanButtonAttributedTitle, for: .normal)
        scanButton.layer.cornerRadius = 0.0
        scanButton.layer.borderColor = Theme.tintColor.cgColor
        scanButton.layer.borderWidth = 1.5
        
        let font = UIFont.systemFont(ofSize: 40)
        
        let closeButtonAttributedTitle = NSAttributedString(string: "x",
                                                            attributes: [NSForegroundColorAttributeName : Theme.primaryColor,
                                                                         NSFontAttributeName: font])
        closeButton.setAttributedTitle(closeButtonAttributedTitle, for: .normal)
        
    }
    
    @IBAction func scanButtonTapped(_ sender: AnyObject) {
        SpartaToast.displayToast("Scanned Hacker XYZ")

    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
