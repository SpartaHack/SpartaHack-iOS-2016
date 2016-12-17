//
//  User.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/25/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation


class User : NSObject {
    var id: Int! = nil
    var token: String! = nil
    var email: String! = nil
    var name: String! = nil
    var roles: [String]! = nil
    
    static let sharedInstance = User()
    
    override init() {
        super.init()
    }
    
    override var debugDescription : String {
        let user =
            "id: \(id!)" +
            "\n name:\(name!)" +
            "\n email:\(email!)" +
            "\n roles:\(roles!)" +
            "\n token: \(token!)"
        return user
    }
}
