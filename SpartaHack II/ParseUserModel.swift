//
//  ParseUserModel.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/28/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import Foundation
import Parse

class ParseUserModel: NSObject {

    func registerUserWithDict(userDict: NSDictionary) -> Bool {
        var newUser = PFUser()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        
        newUser.username = userDict["email"] as? String
        newUser.password = userDict["password"] as? String
        newUser.email = userDict["email"] as? String
        newUser["firstName"] = userDict["firstName"] as? String
        newUser["lastName"] = userDict["lastName"] as? String
        newUser["birthday"] = dateFormatter.dateFromString(userDict["birthday"] as! String)
        newUser["numberOfHackathon"] = userDict["numberOfHackathon"] as? String
        newUser["school"] = userDict["school"] as? String
        
        newUser.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                println("error")
            } else {
                // Hooray! Let them use the app now.
                println("great success!")
                
            }
        }
        
        println("Am i done with the block")
        
        return true
    }
}