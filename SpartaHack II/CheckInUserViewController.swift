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
    @IBOutlet weak var tshirtSizeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let query = PFQuery(className: "_User")
        query.getObjectInBackgroundWithId(objectId) { (object: PFObject?, error:NSError?) -> Void in
            if object != nil {
                var name = ""
                if let firstName = object!["firstName"] as? String {
                    name += firstName
                }
                if let lastName = object!["lastName"] as? String {
                    name += lastName
                }
                self.nameLabel.text = "Name: \(name)"
                let foodQuery = PFQuery(className: "RSVP")
                foodQuery.whereKey("user", equalTo: object!)
                foodQuery.getFirstObjectInBackgroundWithBlock({ (object:PFObject?, error:NSError?) -> Void in
                    if error == nil {
                        if let diets = object!["restrictions"] as? [String] {
                            var dietString = ""
                            for diet in diets {
                                dietString += " \(diet)"
                            }
                            self.dietLabel.text = "Dietary Restriction: \(dietString)"
                        }
                        
                        if let shirt = object!["tshirt"] as? String {
                            self.tshirtSizeLabel.text = "T-Shirt: \(shirt)"
                        }
                    } else {
                        print("error")
                    }
                })
                
                
                if let email = object!["email"] as? String {
                    self.emailLabel.text = "Email: \(email)"
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
            if error == nil {
                let applicationInfo = PFQuery(className: "Application")
                applicationInfo.whereKey("user", equalTo: object!)
                applicationInfo.getFirstObjectInBackgroundWithBlock({ (appObject:PFObject?, error:NSError?) -> Void in
                    if error == nil {
                        let rsvpInfo = PFQuery(className: "RSVP")
                        rsvpInfo.whereKey("user", equalTo: object!)
                        rsvpInfo.getFirstObjectInBackgroundWithBlock({ (rsvpObject:PFObject?, error:NSError?) -> Void in
                            if error == nil {
                                let checkin = PFObject(className: "Attendance")
                                checkin["user"] = object!
                                checkin["application"] = appObject!
                                checkin["rsvp"] = rsvpObject!
                                checkin.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
                                    if success {
                                        print("success")
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    } else {
                                        print("error \(error)")
                                    }
                                }
                            }
                        })
                    }
                })
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
