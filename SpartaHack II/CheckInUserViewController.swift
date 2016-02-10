//
//  CheckInUserViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/6/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

class CheckInUserViewController: UIViewController {

    var objectId = String()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "_User")
        query.getObjectInBackgroundWithId(objectId) { (object: PFObject?, error:NSError?) -> Void in
            if object != nil {
                if let name = object!["name"] as? String {
                    self.nameLabel.text = "Name: \(name)"
                }
                if let email = object!["email"] as? String {
                    self.emailLabel.text = "Email: \(email)"
                }
                if let diet = object!["diet"] as? String {
                    self.dietLabel.text = "Dietary Restriction: \(diet)"
                }
                let alreadyIn = PFQuery(className: "Attendance")
                alreadyIn.whereKey("user", equalTo: object!)
                alreadyIn.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
                    if (objects?.count == 0) {
                        // allow checkin
                    } else {
                        // show alert to dismiss view
                        self.showAlert()
                    }
                }
            } else {
                print(error)
            }
        }
        
        
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "User is Already Checked in", preferredStyle: UIAlertControllerStyle.Alert)
        let okayAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(okayAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptButtonTapped(sender: AnyObject) {
    
        let query = PFQuery(className: "_User")
        query.getObjectInBackgroundWithId(objectId) { (object: PFObject?, error:NSError?) -> Void in
            if object != nil {
                let checkin = PFObject(className: "Attendance")
                checkin["user"] = object!
                checkin.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
                    if success {
                        print("success")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        print("error \(error)")
                    }
                }

            } else {
                print(error)
            }
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
