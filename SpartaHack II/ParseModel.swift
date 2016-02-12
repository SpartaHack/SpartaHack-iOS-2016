//
//  ParseUserModel.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/28/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse
import CoreData

// declare some k constants because changing strings is hard 
let kfirstName = "firstName"
let klastName = "lastName"
let kemailName = "email"
let kpassword = "password"
let kbirthday = "birthday"
let knumberOfHackathons = "numberOfHackathon"
let kschool = "school"
let ktshirtSize = "tshirtSize"
let kgender = "gender"
let kfoodPrefs = "foodPrefs"

@objc protocol ParseModelDelegate {
    optional func didRegisterUser(success: Bool)
}

protocol ParseNewsDelegate {
    func didGetNewsUpdate()
}

protocol ParseUserDelegate {
    func userDidLogin(login: Bool, error: NSError?)
}

protocol ParseHelpDeskDelegate {
    func didGetHelpDeskOptions()
    func didGetUserTickets()
}

protocol ParseScheduleDelegate {
    func didGetSchedule()
}

protocol ParsePrizesDelegate {
    func didGetPrizes()
}

protocol ParseTicketDelegate {
    func didSubmitTicket(success: Bool)
}

protocol ParseSponsorDelegate {
	func didGetSponsors()
}

protocol ParseMentorDelegate {
    func didGetMentorCategories()
}

protocol ParseOpenTicketsDelegate {
    func didGetOpenTickets()
}

class ParseModel: NSObject {
    
    static let sharedInstance = ParseModel()
    var userDict = [String:String]()
    
    var delegate = ParseModelDelegate?()
    var helpDeskDelegate = ParseHelpDeskDelegate?()
    var scheduleDelegate = ParseScheduleDelegate?()
    var userDelegate = ParseUserDelegate?()
    var newsDelegate = ParseNewsDelegate?()
    var prizeDelegate = ParsePrizesDelegate?()
    var ticketDelegate = ParseTicketDelegate?()
	var sponsorDelegate = ParseSponsorDelegate?()
    var mentorDelegate = ParseMentorDelegate?()
    var openTicketDelegate = ParseOpenTicketsDelegate?()
    // Register user with our Parse database
    /*
     - This will be removed soon.
    */
    func registerUserWithDict() {
        let newUser = PFUser()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        
        newUser.username = userDict[kemailName]
        newUser.password = userDict[kpassword]
        newUser.email = userDict[kemailName]
        newUser[kfirstName] = userDict[kfirstName]
        newUser[klastName] = userDict[klastName]
        newUser[kbirthday] = dateFormatter.dateFromString(userDict[kbirthday]!)
        newUser[knumberOfHackathons] = userDict[knumberOfHackathons]
        newUser[kschool] = userDict[kschool]
        
        newUser.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                self.delegate?.didRegisterUser!(false)
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                self.delegate?.didRegisterUser!(true)
                print("great success!")
            }
        }
    }
    
    // save function that takes the entity name, and an array of dicts that match the string key for anyobject (make sure whatever type your passing in is what your core data model expects)
    func save(entity: String, dictAry: [[String:AnyObject]]) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var coreDataObjects = [NSManagedObject]()
        // for all key value pairs, map to the entity in the Core Data Model
        for keyValues in dictAry {
            let parseKey = keyValues["objectId"] as? String
            let fetchRequest = NSFetchRequest(entityName: entity)
            fetchRequest.predicate = NSPredicate(format: "objectId == %@", parseKey!)
            do {
                coreDataObjects = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                if coreDataObjects.count > 0 {
                    // update the object instead of adding more
                    for (key,value) in keyValues {
                        // grab the objectId of the parse object in question (it should be passed in within the dictAry)
                        coreDataObjects[0].setValue(value, forKey: key)
                        do {
                            try managedContext.save()
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                } else {
                    // add the new object
                    let entityToSave =  NSEntityDescription.entityForName(entity, inManagedObjectContext:managedContext)
                    let newManObj = NSManagedObject(entity: entityToSave!, insertIntoManagedObjectContext: managedContext)
                    for (key,value) in keyValues {
                        // grab the objectId of the parse object in question (it should be passed in within the dictAry)
                        newManObj.setValue(value, forKey: key)
                        do {
                            try managedContext.save()
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
        // check to see if the core data result exists in the object were passing to save
        // handles cases where we no longer get updates from parse about an object and we're assuming it has been deleted from parse
        if coreDataObjects.count > 0 {
            for i in 0...coreDataObjects.count {
                guard dictAry[safe:i] != nil else {
                    print("delete the item")
                    managedContext.deleteObject(coreDataObjects[i])
                    continue
                }
            }            
        }

        // there is no data for the request so
        if dictAry.count == 0 {
            self.deleteAllData(entity)
        }
    }
    
    // Get updated news
    func getNews() {
        let query = PFQuery(className: "Announcements")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as [PFObject]? {
                    for news in objects {
                        if let title = news["Title"] as? String {
                            dict.updateValue(title, forKey: "title")
                        }
                        if let description = news["Description"] as? String {
                            dict.updateValue(description, forKey: "newsDescription")
                        }
                        if let pinned = news["Pinned"] as? Bool {
                            dict.updateValue(pinned, forKey: "pinned")
                        }
                        dict.updateValue(news.createdAt! as NSDate, forKey: "createdAt")
                        dict.updateValue(news.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                }
                self.save("News", dictAry: dictAry)
                self.newsDelegate?.didGetNewsUpdate()
            }
        }
    }
    
    func getMentorCategories() {
        let query = PFQuery(className: "Mentors")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.whereKey("mentor", equalTo: (PFUser.currentUser())!)
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as [PFObject]? {
                    for mentor in objects {
                        if let mentorTopics = mentor["categories"] as? [String] {
                            let archive = NSKeyedArchiver.archivedDataWithRootObject(mentorTopics)
                            dict.updateValue(archive, forKey: "categoires")
                        }
                        dict.updateValue(mentor.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                }
                self.save("Mentor", dictAry: dictAry)
                self.mentorDelegate?.didGetMentorCategories()
            }
        }

    }
    
    // Get the options that a user has for the help desk
    func getHelpDeskOptions () {
        let query = PFQuery(className: "HelpDesk")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as [PFObject]? {
                    for ticketSubject in objects {
                        dict.updateValue(ticketSubject["category"] as! String, forKey: "category")
                        if let array = ticketSubject["subCategory"] as? [String] {
                            let archive = NSKeyedArchiver.archivedDataWithRootObject(array)
                            dict.updateValue(archive, forKey: "subCategory")
                        }
                        dict.updateValue(ticketSubject["Description"] as! String, forKey: "ticketSubjectDescription")
                        dict.updateValue(ticketSubject.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                    self.save("TicketSubject", dictAry: dictAry)
                    self.helpDeskDelegate?.didGetHelpDeskOptions()
                }
            }
        }
    }
    
    // Get the tickets (if any) that a user has created 
    func getUserTickets () {
        let query = PFQuery(className: "HelpDeskTickets")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.includeKey("category")
        query.whereKey("user", equalTo: (PFUser.currentUser())!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print (error.userInfo["error"])
            } else {
                if let objects = objects as [PFObject]? {
                    for ticket in objects {
                        if let category = ticket["category"] as? PFObject {
                            dict.updateValue(category["category"] as! String, forKey: "category")
                        }
                        if let description = ticket["description"] as? String {
                            dict.updateValue(description, forKey: "ticketDescrption")
                        }
                        if let location = ticket["location"] as? String {
                            dict.updateValue(location, forKey: "location")
                        }
                        if let status = ticket["status"] as? String {
                            dict.updateValue(status, forKey: "status")
                            var code = 0
                            switch status {
                                case "Open":
                                    code = 0
                                    break
                                case "Accepted":
                                    code = 1
                                    break
                                case "Expired":
                                    code = 2
                                    break
                                default:
                                    code = 0
                                    break
                            }
                            dict.updateValue(code, forKey: "statusNum")
                        }
                        dict.updateValue(ticket.createdAt!, forKey: "createdAt")
                        dict.updateValue(ticket.updatedAt!, forKey: "updatedAt")
                        dict.updateValue(ticket.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                    self.save("Ticket", dictAry: dictAry)
                    self.helpDeskDelegate?.didGetUserTickets()
                }
            }
        }
    }
    
    func getOpenTickets () {
        let query = PFQuery(className: "HelpDeskTickets")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.includeKey("category")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                print (error.userInfo["error"])
            } else {
                if let objects = objects as [PFObject]? {
                    for ticket in objects {
                        let category = ticket["category"] as! PFObject
                        dict.updateValue(category["category"] as! String, forKey: "category")
                        dict.updateValue(ticket["description"] as! String, forKey: "ticketDescrption")
                        dict.updateValue(ticket["location"], forKey: "location")
                        if let status = ticket["status"] as? String {
                            dict.updateValue(status, forKey: "status")
                            var code = 0
                            switch status {
                            case "Open":
                                code = 0
                                break
                            case "Accepted":
                                code = 1
                                break
                            case "Expired":
                                code = 2
                                break
                            default:
                                code = 0
                                break
                            }
                            dict.updateValue(code, forKey: "statusNum")
                        }
                        if let mentor = ticket["mentor"] as? PFObject {
                            dict.updateValue(mentor.objectId!, forKey: "mentorId")
                        } else {
                            dict.updateValue("", forKey: "mentorId")
                        }
                        if let user = ticket["user"] as? PFObject {
                            dict.updateValue(user.objectId!, forKey: "userId")
                            let userQuery = PFQuery(className: "Application")
                            userQuery.whereKey("user", equalTo: user)
                            userQuery.getFirstObjectInBackgroundWithBlock({ (object:PFObject?, error:NSError?) -> Void in
                                if error == nil {
                                    if let firstName = object!["firstName"] as? String {
                                        let lastName = object!["lastName"]
                                        let name = "\(firstName) \(lastName)"
                                        dict.updateValue(name, forKey: "userName")
                                    }
                                }
                            })
                        }
                        dict.updateValue(ticket.createdAt!, forKey: "createdAt")
                        dict.updateValue(ticket.updatedAt!, forKey: "updatedAt")
                        dict.updateValue(ticket.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                    self.save("MentorTickets", dictAry: dictAry)
                    self.openTicketDelegate?.didGetOpenTickets()
                }
            }
        }
    }
    
    func getSchedule() {
        let query = PFQuery(className: "Schedule")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as [PFObject]? {
                    for news in objects {
                        
                        let timeFormatter = NSDateFormatter()
                        timeFormatter.timeStyle = .ShortStyle
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateStyle = .MediumStyle
                        
                        if let title = news["eventTitle"] as? String {
                            dict.updateValue(title, forKey: "eventTitle")
                        }
                        if let description = news["eventDescription"] as? String {
                            dict.updateValue(description, forKey: "eventDescription")
                        }
                        if let location = news["eventLocation"] as? String {
                            dict.updateValue(location, forKey: "eventLocation")
                        }
                        if let time = news["eventTime"] as? NSDate {
                            let formattedTime = timeFormatter.dateFromString(timeFormatter.stringFromDate(time))
                            dict.updateValue(formattedTime!, forKey: "eventTime")
                        }
                        
                        if let date = news["eventTime"] as? NSDate {
                            dict.updateValue(dateFormatter.stringFromDate(date), forKey: "eventDate")
                        }
                        
                        dict.updateValue(news.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                }
                self.save("Event", dictAry: dictAry)
                self.scheduleDelegate?.didGetSchedule()
            }
        }
    }
    
    func getPrizes() {
        let query = PFQuery(className: "Prizes")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.includeKey("sponsor")
        query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as [PFObject]? {
                    for prize in objects {
                        if let sponsor:PFObject = prize["sponsor"] as? PFObject {
                            dict.updateValue(sponsor["name"] as! String, forKey: "sponsor")
                            dict.updateValue(sponsor["level"] as! String, forKey: "tier")
                        } else {
                            dict.updateValue("Nan", forKey: "sponsor")
                            dict.updateValue("Nan", forKey: "tier")
                        }
                        dict.updateValue(prize["name"] as! String, forKey: "name")
                        dict.updateValue(prize["description"] as! String, forKey: "prizeDescription")
                        dict.updateValue(prize.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                }
                self.save("Prize", dictAry: dictAry)
                self.prizeDelegate?.didGetPrizes()
            }
        }
    }
    
    func submitUserTicket(category: String, subject: String, description: String, location:String, subCategory:String) {
        let ticket = PFObject(className: "HelpDeskTickets")
        let ticketSbj = PFObject(withoutDataWithClassName: "HelpDesk", objectId: category)
        ticket["category"] = ticketSbj
        ticket["subject"] = subject
        ticket["description"] = description
        ticket["location"] = location
        ticket["notifiedFlag"] = false
        ticket["subCategory"] = subCategory
        ticket["status"] = "Open"
        ticket["user"] = PFUser.currentUser()!
        ticket.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                // yay it worked!
                print("ticket submitted...")
                self.ticketDelegate?.didSubmitTicket(true)
                self.getUserTickets()
            } else {
                // error
                print(error)
            }
        }
    }
    
    func extendTicket (objectId:String, status:String) {
        let notificationObj = PFObject(withoutDataWithClassName: "HelpDeskTickets", objectId: objectId)
        if status == "" {
            // if we're passing a status the mentor has accepted a ticket
            notificationObj["status"] = status
        } else if status != "Expired" {
            // User must be extending ticket
            notificationObj["status"] = status
            notificationObj["notifiedFlag"] = false
        } else {
            notificationObj["status"] = status
            notificationObj["notifiedFlag"] = true
        }
        notificationObj.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                // yay it worked!
                print("ticket submitted...")
                self.getOpenTickets()
            } else {
                // error
                print(error)
            }
        }
    }
    
    // Login user and send a delegate that classes can subscribe too
    func loginUser (username:String, password:String) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation["user"] = PFUser.currentUser()
                do {
                    try currentInstallation.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                print("User logged in")
                self.getUserTickets()
                self.getHelpDeskOptions()
                self.getMentorCategories()
                self.userDelegate?.userDidLogin(true, error: nil)
            } else {
                // The login failed. Check error to see why.
                print(error?.localizedDescription)
                self.userDelegate?.userDidLogin(false, error: error)
            }
        }
    }
	
	func getSponsors() {
		let query = PFQuery(className: "Company")
		var dict = [String:AnyObject]()
		var dictAry = [[String:AnyObject]]()
		query.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
			if let error = error {
				let errorString = error.userInfo["error"] as? NSString
				// Show the errorString somewhere and let the user try again.
				print("Why must the success codes always be gone? \(errorString)")
			} else {
				// Hooray! Let them use the app now.
				if let objects = objects as [PFObject]? {
					for sponsor in objects {
                        if let userImageFile = sponsor["png"] as? PFFile {
                            dict.updateValue(userImageFile.url!, forKey: "image")
                        }
                        
                        if let name = sponsor["name"] as? String {
                            dict.updateValue(name, forKey: "name")
                        }
                        
                        if let level = sponsor["level"] as? String {
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
                            dict.updateValue(numLevel, forKey: "tier")
                        }
                        
                        dict.updateValue(sponsor.objectId!, forKey: "objectId")
                        dictAry.append(dict)
					}
                    self.save("Sponsor", dictAry: dictAry)
                    self.sponsorDelegate?.didGetSponsors()
				}
			}
		}
	}
    
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}