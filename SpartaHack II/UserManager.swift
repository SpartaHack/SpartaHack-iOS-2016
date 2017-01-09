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
    
    func UserQRCode() -> String? {
        if (isUserScannable()) {
            if let qrCode = spartaUser?.id {
                return String(qrCode)
            }
        }
        return nil
    }
    
    func getFirstName() -> String? {
        if (isUserLoggedIn()) {
            guard spartaUser?.fName == nil else {
                return spartaUser?.fName
            }
        }
        return nil
    }
 
    func getFullName() -> String? {
        if (isUserLoggedIn()) {
            guard ((spartaUser?.fName) == nil), spartaUser?.lName == nil else {
                return (spartaUser?.fName)! + " " + (spartaUser?.lName)!
            }
        }
        return nil
    }
    
    func logOutUser (completionHandler: @escaping(Bool) -> ()) {
        if (isUserLoggedIn()) {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "user")
            defaults.synchronize()
            spartaUser = nil
            completionHandler(true)
        }
        completionHandler(false)
    }
    
    func loginUser (id: Int32, token: String, email: String, fName: String, lName: String, roles: [String], rsvp:AnyObject?, adult: Bool) {
    
        spartaUser = User(id: id, token: token, email: email, fName: fName, lName: lName, roles: roles, rsvp: rsvp, adult: adult)
        
    }
    
    func loadUser () {
        // Load the user if we have one
        
        let defaults = UserDefaults.standard
        
        if let savedUser = defaults.object(forKey: "user") as? Data {
            let unarchivedUser = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as! [User]
            spartaUser = unarchivedUser[0]
        }
    }
}
