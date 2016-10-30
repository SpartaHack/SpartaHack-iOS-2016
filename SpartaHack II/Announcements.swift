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
    private var spartaAnnouncements: [Announcement] = []
    
    // Singleton for Announcments Collection
    static let sharedInstance = Announcements()
    
    override init () {
        super.init()
    }
    
    func addAnnouncement(announcement:Announcement) {
        // adds announcement to our array 
        var valid = true
        
        for announce in spartaAnnouncements {
            // check to see if the id exists in our array 
            if announcement.id == announce.id {
                // reject new entry
                valid = false
            }
        }
        
        if valid {
            spartaAnnouncements.append(announcement)
        }
        
    }
    
    func listOfAnnouncements () -> [Announcement] {
        return spartaAnnouncements
    }
}
