//
//  Announcement.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 9/9/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class Announcement: NSObject {
    var id: Int! = nil
    var title: String! = nil
    var detail: String! = nil
    var pinned: Bool! = false
    var createdTime: NSDate! = nil
    var updatedTime: NSDate! = nil
    
    override init() {
        super.init()
    }
    
    override var debugDescription : String {
        let announcement =
            "id: \(id!)" +
            "\n title:\(title!)" +
            "\n detail:\(detail!)" +
            "\n pinned:\(pinned!)" +
            "\n created:\(createdTime!)" +
            "\n updated:\(updatedTime)"
            
        return announcement
    }
}
