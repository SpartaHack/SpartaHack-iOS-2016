//
//  FakeModel.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 9/9/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation
import Alamofire


/// URL Constants
let baseURL = "https://d.api.spartahack.com/"

class SpartaModel: NSObject {
    
    let formatter = DateFormatter()
    override init () {
        // initalize our data manager and get the current announcements
        super.init()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        // make requests to get our stuff
        getAnnouncements()
        getSchedule()
    }
    
    func getAnnouncements() {
        Alamofire.request("\(baseURL)announcements").responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                return
            }
            // get our announcement data 
            
            if let result = response.result.value {
                if let json = result as? NSDictionary {
                    if let objArray = json["announcements"] as? [NSDictionary] {
                        // loop through our valid json dictionary and create announcement objects that will be added to announcements
                        for obj in objArray {

                            // create announcement objects 
                            let announcement = Announcement()
                            
                            guard let id = obj["id"] as? Int else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            announcement.id = id
                            
                            guard let title = obj["title"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            announcement.title = title
                            
                            guard let detail = obj["description"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            announcement.detail = detail
                            
                            guard let pinned = obj["pinned"] as? Bool else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            announcement.pinned = pinned
                            
                            guard let createdStr = obj["createdAt"] as? String,
                                let createdAt = self.formatter.date(from: createdStr) as NSDate? else {
                                    fatalError("ToDo: gracefully handle error")
                            }
                            announcement.createdTime = createdAt
                            
                            guard let updatedStr = obj["createdAt"] as? String,
                                let updatedAt = self.formatter.date(from: updatedStr) as NSDate? else {
                                    fatalError("ToDo: gracefully handle error")
                            }
                            announcement.updatedTime = updatedAt
                            Announcements.sharedInstance.addAnnouncement(announcement: announcement)
                        }
                    }
                }
            }
        }
    }
    
    func getSchedule() {
        Alamofire.request("\(baseURL)schedule").responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                return
            }
            // get our schedule data
            
            if let result = response.result.value {
                if let json = result as? NSDictionary {
                    if let objArray = json["schedule"] as? [NSDictionary] {
                        // loop through our valid json dictionary and create event objects that will be added to the schedule
                        for obj in objArray {
                            // create event objects
                            let event = Event()
                            
                            guard let id = obj["id"] as? Int else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.id = id
                            
                            guard let title = obj["title"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.title = title
                            
                            guard let detail = obj["description"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.detail = detail
                            
                            guard let timeStr = obj["time"] as? String,
                                let time = self.formatter.date(from: timeStr) as NSDate? else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.time = time
                            
                            guard let location = obj["location"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.location = location
                            
                            guard let updatedString = obj["updatedAt"] as? String,
                                let updatedAt = self.formatter.date(from: updatedString) as NSDate? else {
                                    fatalError("ToDo: gracefully handle error")
                            }
                            event.updatedTime = updatedAt
                            
                            // okay, we haven't crashed by now so we guchi
                            Schedule.sharedInstance.addEvent(event: event)
                        }
                    }
                }
            }
        }
    }
    
}
