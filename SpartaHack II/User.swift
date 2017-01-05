//
//  User.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/25/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation
import Alamofire

class User: NSObject, NSCoding {
    var id: Int32
    var token: String
    var email: String
    var fName: String
    var lName: String
    var roles: [String]

    
    init (id:Int32, token:String, email:String, fName:String, lName:String, roles:[String]) {
        self.id = id
        self.token = token
        self.email = email
        self.fName = fName
        self.lName = lName
        self.roles = roles
        
        super.init()
        saveUser()
    }
    
    
    required init(coder decoder: NSCoder) {
//        guard let id = decoder.decodeObject(forKey: "id") as? Int32,
//            let token = decoder.decodeObject(forKey: "token") as? String,
//            let email = decoder.decodeObject(forKey: "email") as? String,
//            let fName = decoder.decodeObject(forKey: "firstName") as? String,
//            let lName = decoder.decodeObject(forKey: "lastName") as? String,
//            let roles = decoder.decodeObject(forKey: "roles") as? [String]
//            else { return }
        
//        self.init(
//            self.id = id
//            self.token = token
//            self.email = email
//            self.fName = fName
//            self.lName = lName
//            self.roles = roles
//        )

        self.id = decoder.decodeInt32(forKey: "id")
        self.token = decoder.decodeObject(forKey: "token") as? String ?? ""
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.fName = decoder.decodeObject(forKey: "firstName") as? String ?? ""
        self.lName = decoder.decodeObject(forKey: "lastName") as? String ?? ""
        self.roles = decoder.decodeObject(forKey: "roles") as? [String] ?? [""]

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fName, forKey: "firstName")
        aCoder.encode(lName, forKey: "lastName")
        aCoder.encode(roles, forKey: "roles")
    }
    
    override var debugDescription : String {
        let user =
            "id: \(id)" +
            "\n First Name:\(fName)" +
            "\n Last Name:\(lName)" +
            "\n email:\(email)" +
            "\n roles:\(roles)" +
            "\n token: \(token)"
        return user
    }
    
    func getFirstName () -> String {
        guard fName != "" else {
            return "N/A"
        }
        return fName
    }
    
    func saveUser () {
        var userToSave = [User]()
        userToSave.append(self)
        let savedData: Data = NSKeyedArchiver.archivedData(withRootObject: userToSave)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: "user")
        defaults.synchronize()
        print("Saved successfully")
        
//        let encodedData = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [User]
//
//        print("\(encodedData)")
    }
}
