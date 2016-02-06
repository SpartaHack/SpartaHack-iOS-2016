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
    
    var user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userNameLabel.text = "Welcome: \(user!.username!)"

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
                let result = try generator.encode(PFUser.currentUser()!.objectId! , format: kBarcodeFormatCode128, width: 500, height: 100)
                let image = ZXImage(matrix: result).cgimage
                userBarCodeImageView.image = UIImage(CGImage: image)
            } catch {
                let error = error as NSError
                print("\(error), \(error.userInfo)")
            }
//            let result = generator.encode(PFUser.currentUser()!.objectId! , format: kBarcodeFormatCode128, width: 100, height: 100)

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
