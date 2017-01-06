//
//  Sponsor.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/11/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class Sponsor: NSObject {
    var id: Int! = nil
    var name: String! = nil
    var level: String! = nil
    var logo: UIImage! = nil
    var url: String! = nil
    
    override init() {
        super.init()
    }
    
    override var debugDescription : String {
        let sponsor =
            "id: \(id!)" +
                "\n name:\(name!)" +
                "\n level:\(level!)" +
                "\n url:\(url!)"
        
        return sponsor
    }
}
