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
    func userDidLogin(login: Bool)
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
        
        // for all key value pairs, map to the entity in the Core Data Model
        for keyValues in dictAry {
            let parseKey = keyValues["objectId"] as? String
            let fetchRequest = NSFetchRequest(entityName: entity)
            fetchRequest.predicate = NSPredicate(format: "objectId == %@", parseKey!)
            do {
                let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                if result.count > 0 {
                    // update the object instead of adding more
                    print("")
                    print("Updating Existing Object!")
                    print("")
                    for (key,value) in keyValues {
                        // grab the objectId of the parse object in question (it should be passed in within the dictAry)
                        print("Save: ","\(key)","\(value)")
                        result[0].setValue(value, forKey: key)
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
                    print("")
                    print("Adding New Object!")
                    print("")
                    for (key,value) in keyValues {
                        // grab the objectId of the parse object in question (it should be passed in within the dictAry)
                        print("Save: ","\(key)","\(value)")
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
    }
    
    // Get updated news
    func getNews() {
        let query = PFQuery(className: "Announcements")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as? [PFObject] {
                    for news in objects {
                        print(news)
                        dict.updateValue(news["Title"] as! String, forKey: "title")
                        dict.updateValue(news["Description"] as! String, forKey: "newsDescription")
                        dict.updateValue(news["Pinned"]! , forKey: "pinned")
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
    
    // Get the options that a user has for the help desk
    func getHelpDeskOptions () {
        let query = PFQuery(className: "HelpDesk")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as? [PFObject] {
                    for ticketSubject in objects {
                        print(ticketSubject)
                        dict.updateValue(ticketSubject["category"] as! String, forKey: "category")
                        dict.updateValue(ticketSubject["Description"] as! String, forKey: "ticketSubjectDescription")
                        dict.updateValue(ticketSubject.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                    self.save("TicketSubject", dictAry: dictAry)
                    self.helpDeskDelegate?.didGetHelpDeskOptions()
                }
                print("great success!")
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
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                print (error.userInfo["error"])
            } else {
                if let objects = objects as? [PFObject] {
                    for ticket in objects {
                        print(ticket)
                        let category = ticket["category"] as! PFObject
                        dict.updateValue(category["category"] as! String, forKey: "category")
                        dict.updateValue(ticket["description"] as! String, forKey: "ticketDescrption")
                        dict.updateValue(ticket.objectId!, forKey: "objectId")
                        dictAry.append(dict)
                    }
                    self.save("Ticket", dictAry: dictAry)
                    self.helpDeskDelegate?.didGetUserTickets()
                }
            }
        }
    }
    
    func getSchedule() {
        let query = PFQuery(className: "Schedule")
        var dict = [String:AnyObject]()
        var dictAry = [[String:AnyObject]]()
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as? [PFObject] {
                    for news in objects {
                        print(news)
                        dict.updateValue(news["eventTitle"] as! String, forKey: "eventTitle")
                        dict.updateValue(news["eventDescription"] as! String, forKey: "eventDescription")
                        dict.updateValue(news["eventLocation"] as! String, forKey: "eventLocation")
                        dict.updateValue(news["eventTime"] as! NSDate, forKey: "eventTime")
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
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print("Why must the success codes always be gone? \(errorString)")
            } else {
                // Hooray! Let them use the app now.
                if let objects = objects as? [PFObject] {
                    for prize in objects {
                        print(prize)
                        let sponsor:PFObject = prize["sponsor"] as! PFObject
                        dict.updateValue(sponsor["name"] as! String, forKey: "sponsor")
                        dict.updateValue(sponsor["level"] as! String, forKey: "tier")
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
    
    func submitUserTicket(category: String, subject: String, description: String) {
        let ticket = PFObject(className: "HelpDeskTickets")
        let ticketSbj = PFObject(withoutDataWithClassName: "HelpDesk", objectId: category)
        ticket["category"] = ticketSbj
        ticket["subject"] = subject
        ticket["description"] = description
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
    
    // Login user and send a delegate that classes can subscribe too
    func loginUser (username:String, password:String) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation["user"] = PFUser.currentUser()
                currentInstallation.save()
                print("User logged in")
                self.getUserTickets()
                self.getHelpDeskOptions()
                self.userDelegate?.userDidLogin(true)
            } else {
                // The login failed. Check error to see why.
                print(error?.localizedDescription)
                self.userDelegate?.userDidLogin(false)
            }
        }
    }
	
	func getSponsors() {
		let query = PFQuery(className: "Company")
		var dict = [String:AnyObject]()
		var dictAry = [[String:AnyObject]]()
		query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]?, error: NSError?) -> Void in
			if let error = error {
				let errorString = error.userInfo["error"] as? NSString
				// Show the errorString somewhere and let the user try again.
				print("Why must the success codes always be gone? \(errorString)")
			} else {
				// Hooray! Let them use the app now.
				if let objects = objects as? [PFObject] {
					for sponsor in objects {
						print(sponsor)
						let userImageFile = sponsor["png_img"] as! PFFile
						userImageFile.getDataInBackgroundWithBlock {
							(imageData: NSData?, error: NSError?) -> Void in
							if error == nil {
								if let imageData = imageData {
									let image = UIImage(data:imageData)
                                    dict.updateValue(sponsor.objectId!, forKey: "objectId")
                                    dict.updateValue(sponsor["name"] as! String, forKey: "sponsor")
                                    dict.updateValue(sponsor["level"] as! String, forKey: "tier")
									dict.updateValue(UIImagePNGRepresentation(image!)!, forKey: "image")
									dictAry.append(dict)
								}
							}
						}
					}
				}
				self.save("Sponsor", dictAry: dictAry)
				self.sponsorDelegate?.didGetSponsors()
			}
		}
	}
	

}