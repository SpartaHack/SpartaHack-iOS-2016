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
    
    override init () {
        super.init()
        // initalize our data manager and get the current announcements
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
                            announcement.id = obj["id"] as? String
                            announcement.title = obj["title"] as? String
                            announcement.detail = obj["description"] as? String
                            announcement.pinned = obj["pinned"] as? Bool
                            announcement.createdTime = obj["createdAt"] as? NSDate
                            announcement.updatedTime = obj["updatedAt"] as? NSDate
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
                            // create a time formatter so we all good
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
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
                                let time = formatter.date(from: timeStr) as NSDate? else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.time = time
                            
                            guard let location = obj["location"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.location = location
                            
                            guard let createdString = obj["createdAt"] as? String,
                                let createdAt = formatter.date(from: createdString) as NSDate? else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            event.createdTime = createdAt
                            
                            guard let updatedString = obj["updatedAt"] as? String,
                                let updatedAt = formatter.date(from: updatedString) as NSDate? else {
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
