//
//  ParseUserModel.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/28/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

// declare some k constants because changing strings is hard 
let kfirstName = "firstName"
let klastName = "lastName"
let kemailName = "email"
let kpassword = "password"
let kbirthday = "birthday"
let knumberOfHackathons = "numberOfHackathon"
let kschool = "school"
let ktshirtSize = "tshirtSize"
let kgender = "gender"
let kfoodPrefs = "foodPrefs"

@objc protocol ParseModelDelegate {
    optional func didRegisterUser(success: Bool)
    optional func didGetNewsUpdate(data: [PFObject])
}


class ParseModel: NSObject {
    
    static let sharedInstance = ParseModel()
    var userDict = [String:String]()
    var delegate = ParseModelDelegate?()
    
    // Register user with our Parse database
    func registerUserWithDict() {
        var newUser = PFUser()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        
        newUser.username = userDict[kemailName]
        newUser.password = userDict[kpassword]
        newUser.email = userDict[kemailName]
        newUser[kfirstName] = userDict[kfirstName]
        newUser[klastName] = userDict[klastName]
        newUser[kbirthday] = dateFormatter.dateFromString(userDict[kbirthday]!)
        newUser[knumberOfHackathons] = userDict[knumberOfHackathons]
        newUser[kschool] = userDict[kschool]
        
        newUser.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                self.delegate?.didRegisterUser!(false)
                println("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                self.delegate?.didRegisterUser!(true)
                println("great success!")
            }
        }
    }
    
    // Get updated news
    func getNews() {
        var query = PFQuery(className: "Announcements")
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                println("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as? [PFObject] {
                    self.delegate?.didGetNewsUpdate!(objects)
                }
                println("great success!")
            }
        }
    }
    
    
}