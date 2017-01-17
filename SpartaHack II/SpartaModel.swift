//
//  SpartaModel.swift
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
    var sessionManager = Alamofire.SessionManager.default
    
    static let sharedInstance = SpartaModel()
    
    override init () {
        // initalize our data manager and get the current announcements
        super.init()
        
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        
        // make requests to get our stuff
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15.0 /// 15 second timeout.
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    /// Push the user tokens
    func sendDeviceToken( token:String, completionHandler: @escaping(Bool) -> () ) {
        
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
    
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)installations")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: String] = [
            "device_type" : "iOS",
            "token" : token
            ]
        
        do {
            try urlRequest.httpBody = JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        sessionManager.request(urlRequest).responseJSON { response in
            debugPrint(response)
            if let value = response.result.value as? [String:AnyObject] {
                if let error = (value["errors"] as? [String:AnyObject])?["invalid"]?.objectAt(0) as? String {
                    print("OMG get bogdan and/or chris: \(error)")
                    completionHandler(false)
                } else {
                    print(value)
                    completionHandler(true)
                }
            }
        }
    }
    
    
    /// Announcements
    func getAnnouncements( completionHandler: @escaping(Bool) -> () ) {
    
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
        
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)announcements")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
    
        sessionManager.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                completionHandler(false)
                return
            }
            // get our announcement data 
            
            if let result = response.result.value {
                if let json = result as? [NSDictionary] {
                    for obj in json {
                        
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
                        
                        guard let createdStr = obj["created_at"] as? String,
                            let createdAt = self.formatter.date(from: createdStr) as NSDate? else {
                                fatalError("ToDo: gracefully handle error")
                        }
                        announcement.createdTime = createdAt
                        
                        guard let updatedStr = obj["updated_at"] as? String,
                            let updatedAt = self.formatter.date(from: updatedStr) as Date? else {
                                fatalError("ToDo: gracefully handle error")
                        }
                        announcement.updatedTime = updatedAt as NSDate?
                        Announcements.sharedInstance.addAnnouncement(announcement: announcement)
                    }
                    completionHandler(true)

                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    /// Schedule
    func getSchedule( completionHandler: @escaping(Bool) -> () ) {
    
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
    
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)schedule")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
    
        sessionManager.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                completionHandler(false)
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
                            
                            guard let updatedString = obj["updated_at"] as? String,
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
    func getMap( completionHandler: @escaping(URL?) -> () ) {
        
        var filePath: URL?

        let destination: (URL, HTTPURLResponse) -> (URL, DownloadRequest.DownloadOptions) = {
            (temporaryURL, response) in
            
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let suggestedFilename = response.suggestedFilename {
                filePath = directoryURL.appendingPathComponent("\(suggestedFilename)")
                return (filePath!, [.removePreviousFile, .createIntermediateDirectories])
            }
            return (temporaryURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        sessionManager.download("\(baseURL)map.pdf", to: destination).response { response in
            print(response)
            
            if response.error == nil, let imagePath = response.destinationURL?.path {
                let URLRequest = URL(fileURLWithPath: imagePath)
                print("\(URLRequest)")
                completionHandler(URLRequest)
            }
        }
        completionHandler(nil)
    }
    
    /// post for Mentorship
    func postMentorship (category:String, location:String, description:String, completionHandler: @escaping(String?) -> () ) {
        
        if category == "" {
            completionHandler("Invalid Category")
            return
        }
        
        if location == "" {
            completionHandler("Location Required")
            return
        }
        
        var urlRequest = URLRequest(url: URL(string: "https://hooks.slack.com/services/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")!)
        urlRequest.httpMethod = "POST"
        
        let lowerCategory = category.lowercased()
        let channelStr = "#\(lowerCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: ".", with: ""))"
        
        let payload: [String: String] = [
            "channel" : channelStr,
            "username" : "(\(location)) \(UserManager.sharedInstance.getFullName()!)",
            "text" : description,
            ]
        
        do {
            try urlRequest.httpBody = JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        sessionManager.request(urlRequest).responseString { response in
            debugPrint(response)
            let value = response.result.value! as String
                if value != "ok" {
                    print("Error signing in: \(value)")
                    completionHandler(value)
                } else {
                    completionHandler(nil)
                    print("Response: \(value)")
                }
            }
    }
    
    /// getSponsors
    func getSponsors( completionHandler: @escaping(Bool) -> () ) {
    
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
    
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)sponsors")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
    
        sessionManager.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                completionHandler(false)
                return
            }
            // get our schedule data
            
            if let result = response.result.value {
                if let json = result as? [NSDictionary] {
                    for obj in json {
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
                        
                        var numLevel = 0
                        
                        switch level {
                            case "legend" :
                                numLevel = 1
                                break
                            case "commander" :
                                numLevel = 2
                                break
                            case "warrior" :
                                numLevel = 3
                                break
                            case "trainee" :
                                numLevel = 4
                                break
                            default:
                                numLevel = 5
                                break
                        }
                        
                        sponsor.level = numLevel as NSNumber
                        
                        guard let logoString = obj["logo_png_light"] as? String else {
                            fatalError("ToDo: gracefully handle error")
                        }
                        let logoData = NSData(base64Encoded: logoString.substring(from: logoString.index(logoString.startIndex, offsetBy: 22)), options: NSData.Base64DecodingOptions(rawValue: 0))
                        sponsor.logo = UIImage(data: logoData as! Data)
                        
                        print("Name: \(sponsor.name)  image: \(sponsor.logo)")
                        
                        guard let url = obj["url"] as? String else {
                            fatalError("ToDo: gracefully handle error")
                        }

                        sponsor.url = url
                        
                        // okay, we haven't crashed by now so we guchi
                        Sponsors.sharedInstance.addSponsor(sponsor: sponsor)
                    }
                    completionHandler(true)
                }
            }
        }
    }
    
    /// Prizes
    func getPrizes( completionHandler: @escaping(Bool) -> () ) {
    
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
    
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)prizes")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
        
        sessionManager.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                completionHandler(false)
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
    /// check in the user 
    func validateCheckin (idString:String, completionHandler: @escaping(Bool, String?) -> () ) {
        
        let parameters: [String: String] = [
            "id" : idString,
            ]
        
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)checkin")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("\(UserManager.sharedInstance.getUserToken()!)", forHTTPHeaderField: "X-WWW-USER-TOKEN")
        
        do {
            try urlRequest.httpBody = JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        sessionManager.request(urlRequest).responseJSON { response in
            debugPrint(response)
            if let value = response.result.value as? [String:AnyObject] {
                if let error = (value["errors"] as? [String:AnyObject])?["user"]?.objectAt(0) as? String {
                    print("Error signing in: \(error)")
                    completionHandler(false, "Reason: \(error)")
                } else if let error = value["api"] as? [String] {
                    completionHandler(false, "Reason: \(error)")
                } else {
                    completionHandler(true, "Successful checkin!")
                }
            }
        }
    }
    
    /// Get slack channels 
    func getChannels (completionHandler: @escaping([NSDictionary]?) -> () ) {
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }
        
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)categories")!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Token token=\(keyDict!.object(forKey: "baseAPIKey") as! String)", forHTTPHeaderField: "Authorization")
        
        sessionManager.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                // we failed for some reason
                print("Error \(response.result.error)")
                completionHandler(nil)
                return
            }
            // get our prize data
            
            if let result = response.result.value {
                if let json = result as? [NSDictionary] {
                    completionHandler(json)
                }
            }
        }
    }
    
    /// log user in and grab token
    func getUserSession ( email:String, password:String, completionHandler: @escaping(Bool) -> () ) {
    
        var keyDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keyDict = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("You need to configure the keys.plist file. Don't commit API keys to a remote repository.... Please.")
        }

        let parameters: [String: String] = [
            "email" : email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
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
        
        sessionManager.request(urlRequest).responseJSON { response in
            debugPrint(response)
            if let value = response.result.value as? [String:AnyObject] {
                if let error = (value["errors"] as? [String:AnyObject])?["invalid"]?.objectAt(0) as? String {
                    print("Error signing in: \(error)")
                } else {
                    
                    guard let userYear = value["application"]?["birth_year"] as? Int,
                    let userMonth = value["application"]?["birth_month"] as? Int,
                    let userDay = value["application"]?["birth_day"] as? Int else {
                        return
                    }
                    
                    let birthday = "\(userDay) \(userMonth) \(userYear)"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MM yyyy"
                    
                    let date = Date()
                    let calendar = Calendar.current
                    
                    let day = calendar.component(.day, from: date)
                    let month = calendar.component(.month, from: date)
                    var year = calendar.component(.year, from: date)
                    year = year - 18
                    
                    print("18 \(dateFormatter.date(from: "\(day) \(month) \(year)")!)")
                    
                    print("Bday: \(dateFormatter.date(from: birthday)!)")
                    
                    let over18 = dateFormatter.date(from: birthday)! < dateFormatter.date(from: "\(day) \(month) \(year)")!
                    
                    guard let id = value["id"] as? Int32,
                        let token = value["auth_token"] as? String,
                        let email = value["email"] as? String,
                        let fName = value["first_name"] as? String,
                        let lName = value["last_name"] as? String,
                        let roles = value["roles"] as? [String]
                        else {
                            print("Error Creating User \(value)")
                            return
                        }
                        let rsvp = value["rsvp"] as? NSDictionary
                    UserManager.sharedInstance.loginUser(id: id,
                                                    token: token,
                                                    email: email,
                                                    fName: fName,
                                                    lName: lName,
                                                    roles: roles,
                                                    rsvp: rsvp,
                                                    adult: over18,
                    completionHandler: { (success:Bool) in
                            if success{
                                completionHandler(true)
                                print("User Obj: \(UserManager.sharedInstance.isUserLoggedIn())")
                                print("\n\n\n *** 1:\(UserManager.sharedInstance.getFirstName()) *** \n\n\n")

                            } else {
                                completionHandler(false)
                            }
                        })
                }
            }
        }
    }
}
