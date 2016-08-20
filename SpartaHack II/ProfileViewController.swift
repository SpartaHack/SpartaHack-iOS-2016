//
//  ProfileViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/28/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import ZXingObjC

class ProfileViewController: UIViewController, LoginViewControllerDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBarCodeImageView: UIImageView!
    @IBOutlet weak var volunteerButton: UIButton!
    @IBOutlet var profileView: UIView!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // fix overrides 
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.spartaMutedGrey().cgColor
        logoutButton.layer.cornerRadius = 1
        logoutButton.tintColor = UIColor.spartaGreen()
        logoutButton.backgroundColor = UIColor.spartaBlack()
        profileView.backgroundColor = UIColor.spartaBlack()
        
        self.scanButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        }
    
    func userSuccessfullyLoggedIn(_ result: Bool) {
        if !result {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
