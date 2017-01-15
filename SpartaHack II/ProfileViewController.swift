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
    var qrcodeImage: CIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // ToDo: Chris, you need a getter to check if the current user can scan people in
        //        if UserManager.sharedInstance.isAllowedToScanAttendees {
        //            self.scanningButton.removeFromSuperview()
        //        }
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
        
        
        self.displayQRCode()

    }
    
    func displayQRCode() {
        if qrcodeImage == nil {
            
            if UserManager.sharedInstance.UserQRCode() != nil{
                let filter = CIFilter(name: "CIQRCodeGenerator")
                
                filter!.setValue(UserManager.sharedInstance.UserQRCode()!.data(using: String.Encoding.utf8), forKey: "inputMessage")
                filter!.setValue("Q", forKey: "inputCorrectionLevel")
                
                qrcodeImage = filter!.outputImage
                
                let scaleX = self.qrImageView.frame.size.width / qrcodeImage.extent.size.width
                let scaleY = self.qrImageView.frame.size.height / qrcodeImage.extent.size.height
                
                let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
                
                self.qrImageView.image = UIImage(ciImage: transformedImage)
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonTapped(_ sender: AnyObject) {
        UserManager.sharedInstance.logOutUser(completionHandler: { _ in
            self.dismiss(animated: true, completion: {
                SpartaToast.displayToast("You have logged out")
                if let navBar = UIApplication.topViewController()?.navigationController?.navigationBar as? SpartaNavigationBar {
                    navBar.setName(to: "")
                }
            })
        })
    }
    
    @IBAction func volunteerScanningButtonTapped(_ sender: AnyObject) {
        let checkInViewController: CheckInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "checkin") as! CheckInViewController
        self.present(checkInViewController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
