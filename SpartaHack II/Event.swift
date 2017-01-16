//
//  Event.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 10/23/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class Event: NSObject {
    var id: Int! = nil
    var title: String! = nil
    var detail: String! = nil
    var time: NSDate? = nil
    var location: String! = nil
    var updatedTime: NSDate? = nil
    
    override init() {
        super.init()
    }
    
    override var debugDescription : String {
        let event =
            "id: \(id!)" +
                "\n title:\(title!)" +
                "\n detail:\(detail!)" +
                "\n time:\(time)" +
                "\n location:\(location!)" +
        "\n updated:\(updatedTime)"
        
        return event
    }
}
