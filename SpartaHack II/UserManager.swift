//
//  UserManager.swift
//  SpartaHack 2017
//
//  Created by Chris McGrath on 1/6/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    // Singleton for the manager
    static let sharedInstance = UserManager()
    
    private var spartaUser: User?
    
    override init() {
        super.init()
        self.loadUser()
    }
    
    func isUserLoggedIn() -> Bool {
        // Check if user is logged in, if not show login screen
        guard spartaUser != nil else {
            return false
        }
        return true
    }
    
    func isUserScannable() -> Bool {
        // checks to make sure that the logged in user has an rsvp form
        if (isUserLoggedIn()) {
            guard spartaUser?.rsvp != nil else {
                return false
            }
            return true
        }
        return false
    }
    
    func isUserCheckedIn() -> Bool {
        return false
    }
    
    func UserQRString() -> String {
        if (isUserScannable()) {
            if let qrCode = spartaUser?.id {
                return String(qrCode)
            }
        }
        return ""
    }
    
    func logOutUser (completionHandler: @escaping(Bool) -> ()) {
        if (isUserLoggedIn()) {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "user")
            defaults.synchronize()
            completionHandler(true)
        }
        completionHandler(false)
    }
    
    func loadUser () {
        // Load the user if we have one
        
        let defaults = UserDefaults.standard
        
        if let savedUser = defaults.object(forKey: "user") as? Data {
            let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as! [User]
            print("\(unarchivedUser)")
            spartaUser = unarchivedUser[0]
        }
    }
}
