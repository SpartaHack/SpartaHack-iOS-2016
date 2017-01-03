//
//  User.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/25/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation
import Alamofire

class User : NSObject {
    var id: Int! = nil
    var token: String! = nil
    var email: String! = nil
    var fName: String! = nil
    var lName: String! = nil
    var roles: [String]! = nil
    
    static let sharedInstance = User()
    
    override init() {
        super.init()
    }
    
    override var debugDescription : String {
        let user =
            "id: \(id!)" +
            "\n First Name:\(fName!)" +
            "\n Last Name:\(lName!)" +
            "\n email:\(email!)" +
            "\n roles:\(roles!)" +
            "\n token: \(token!)"
        return user
    }
    
    func createUser (userDict: [String:AnyObject]) {
        guard let userId = userDict["id"] as? Int else {
            print("Error unable to create user, userId error")
            return
        }
        id = userId

        guard let authToken = userDict["auth_token"] as? String else {
            print("Error unable to create user, token error")
            return
        }
        token = authToken
        
        guard let userEmail = userDict["email"] as? String else {
            print("Error unable to create user, token error")
            return
        }
        email = userEmail
        
        guard let firstName = userDict["first_name"] as? String else {
            print("Error unable to create user, token error")
            return
        }
        fName = firstName
        
        guard let lastName = userDict["last_name"] as? String else {
            print("Error unable to create user, token error")
            return
        }
        lName = lastName
        
        guard let userRoles = userDict["roles"] as? [String] else {
            print("Error unable to create user, token error")
            return
        }
        roles = userRoles
        
        
        print("User \(self.debugDescription)")
    }
    
    func getFirstName () -> String {
        guard fName != "" else {
            return "N/A"
        }
        return fName
    }
}
