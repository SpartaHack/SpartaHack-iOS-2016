//
//  Announcements.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 9/9/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation


class Announcements: NSObject {
    // holds the collection of announcements 
    var spartaAnnouncements: [Announcement] = []
    
    // Singleton for Announcments Collection
    static let sharedInstance = Announcements()
    
    override init () {
        super.init()
        createFakeAnnouncements()
    }
    
    func createFakeAnnouncements () {
        
        let testAnnouncement = Announcement()
        testAnnouncement.id = "1234"
        testAnnouncement.title = "Testing 123"
        testAnnouncement.detail = "this is a test post"
        testAnnouncement.pinned = false
        testAnnouncement.createdTime = NSDate()
        testAnnouncement.updatedTime = nil
        
        self.spartaAnnouncements.append(testAnnouncement)
    }
}
