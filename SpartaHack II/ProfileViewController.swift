//
//  ProfileViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/28/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse
import ZXingObjC

class ProfileViewController: UIViewController, LoginViewControllerDelegate {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBarCodeImageView: UIImageView!
    @IBOutlet weak var volunteerButton: UIButton!
    @IBOutlet var profileView: UIView!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        logoutButton.layer.borderWidth = 2
        logoutButton.layer.borderColor = UIColor.spartaGreen().CGColor
        logoutButton.layer.cornerRadius = 4
        logoutButton.backgroundColor = UIColor.spartaBlack()
        profileView.backgroundColor = UIColor.spartaBlack()
        
        let query = PFQuery(className: "_User")
        query.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) { (object:PFObject?, error:NSError?) -> Void in
            if error == nil {
                let role = object!["role"] as! String
                if role != "admin" && role != "volunteer" {
                    self.scanButton.hidden = true
                }
                var name = ""
                if let firstName = object!["firstName"] as? String {
                    name += firstName
                }
                if let lastName = object!["lastName"] as? String {
                    name += " \(lastName)"
                }
                self.userNameLabel.text = "Welcome: \(name)"
            } else {
                print("error \(error)")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            vc.delegate = self
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        } else {
            // generate barcode for the user 
            let generator = ZXMultiFormatWriter()
            do {
                let result = try generator.encode(PFUser.currentUser()!.objectId! , format: kBarcodeFormatCode128, width: 870, height: 354)
                let image = ZXImage(matrix: result).cgimage
                userBarCodeImageView.image = UIImage(CGImage: image)
            } catch {
                let error = error as NSError
                print("\(error), \(error.userInfo)")
            }
        }
    }
    
    func userSuccessfullyLoggedIn(result: Bool) {
        if !result {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        PFUser.logOut()
        print("logged out")
        self.navigationController?.popToRootViewControllerAnimated(true)
        ParseModel.sharedInstance.deleteAllData("Ticket")
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
