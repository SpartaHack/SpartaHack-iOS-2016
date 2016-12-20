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
    }
    
    /// Announcements
    func getAnnouncements( completionHandler: @escaping(Bool) -> () ) {
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
                        completionHandler(true)
                    }
                }
            }
        }
    }
    
    /// Schedule
    func getSchedule( completionHandler: @escaping(Bool) -> () ) {
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
                    completionHandler(true)
                }
            }
        }
    }
    
    /// Map
    func getMap( completionHandler: @escaping(Bool) -> () ) {
//        let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory, in: .userDomainMask)
//        
//        Alamofire.download("\(baseURL)map.pdf")
//            .downloadProgress { progress in
//                print("Download Progress: \(progress.fractionCompleted)")
//            }
//            .responseData { response in
//                print(response)
//                if let data = response.result.value {
//                    let image = UIImage(data: data)
//                    print(image as Any);
//                }
//            }
    }
    
    /// getSponsors
    func getSponsors( completionHandler: @escaping(Bool) -> () ) {
        Alamofire.request("\(baseURL)companies").responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                return
            }
            // get our schedule data
            
            if let result = response.result.value {
                if let json = result as? NSDictionary {
                    if let objArray = json["companies"] as? [NSDictionary] {
                        // loop through our valid json dictionary and create event objects that will be added to the schedule
                        for obj in objArray {
                            // create event objects
                            let sponsor = Sponsor()
                            
                            guard let id = obj["id"] as? Int else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            sponsor.id = id
                            
                            guard let name = obj["name"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            sponsor.name = name
                            
                            guard let level = obj["level"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            sponsor.level = level
                            
                            guard let logo = obj["logo_png"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            sponsor.logo = logo
                            
                            guard let url = obj["url"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            sponsor.url = url
                            
                            guard let updatedString = obj["updatedAt"] as? String,
                                let updatedAt = self.formatter.date(from: updatedString) as NSDate? else {
                                    fatalError("ToDo: gracefully handle error")
                            }
                            sponsor.updatedTime = updatedAt
                            
                            // okay, we haven't crashed by now so we guchi
                            Sponsors.sharedInstance.addSponsor(sponsor: sponsor)
                        }
                    }
                    completionHandler(true)
                }
            }
        }
    }
    
    /// Prizes
    func getPrizes( completionHandler: @escaping(Bool) -> () ) {
        Alamofire.request("\(baseURL)prizes").responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                return
            }
            // get our prize data
            
            if let result = response.result.value {
                if let json = result as? NSDictionary {
                    if let objArray = json["prizes"] as? [NSDictionary] {
                        // loop through our valid json dictionary and create announcement objects that will be added to announcements
                        for obj in objArray {
                            
                            // create announcement objects
                            let prize = Prize()
                            
                            guard let id = obj["id"] as? Int else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            prize.id = id
                            
                            // ToDo: Chris, can you get the Sponsors hooked up with the Prizes?                            
                            
                            guard let name = obj["name"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            prize.name = name
                            
                            guard let detail = obj["description"] as? String else {
                                fatalError("ToDo: gracefully handle error")
                            }
                            prize.detail = detail
                            
                            Prizes.sharedInstance.addPrize(prize: prize)
                        }
                        completionHandler(true)
                    }
                }
            }
        }
    }
    
    /// log user in and grab token
    func getUserSession (email:String, password:String) {
        var keyDict: NSDictionary?
        
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
    

        let parameters: [String: String] = [
            "email" : email,
            "password" : password,
        ]
        
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)sessions")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("vnd.example.v2", forHTTPHeaderField: "Accept")
        
        do {
            try urlRequest.httpBody = JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        Alamofire.request(urlRequest).responseJSON { response in
            debugPrint(response)
        }
    }
}
