//
//  ConciergeViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 9/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse
import CoreData

class helpDeskCell: UITableViewCell {
    static let cellIdentifier = "helpCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

class HelpDeskTableViewController: UITableViewController, ParseModelDelegate, ParseHelpDeskDelegate {
    
    var ticketOptionsAry = [NSManagedObject]()
    var ticketsArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        ParseModel.sharedInstance.helpDeskDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("")
        print("Updating Data....")
        print("")
        if PFUser.currentUser() != nil{
            print("")
            print("User is logged in")
            print("")
            self.loadData("TicketSubject", section: 0)
            self.loadData("Ticket", section: 1)
        } else {
            print("")
            print("User is logged out")
            print("")
            ticketOptionsAry.removeAll()
            ticketsArray.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func didGetHelpDeskOptions() {
        print("update!")
        self.loadData("TicketSubject", section: 0)
    }
    
    func didGetUserTickets() {
        self.loadData("Ticket", section: 1)
    }
    
    func loadData (entity: String, section: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            if entity == "Ticket" {
                ticketsArray  = results as! [NSManagedObject]
            } else {
                ticketOptionsAry = results as! [NSManagedObject]
            }
            self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Fade)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(helpDeskCell.cellIdentifier) as! helpDeskCell
        
        if indexPath.section == 0 {
            if ticketOptionsAry.count > 0 {
                let ticketSubject = ticketOptionsAry[indexPath.row]
                cell.titleLabel?.text = ticketSubject.valueForKey("category") as? String
                cell.descriptionLabel?.text = ticketSubject.valueForKey("ticketSubjectDescription") as? String
            } else {
                cell.titleLabel?.text = "Authentication Required"
                cell.descriptionLabel?.text = "Please login to use help desk features"
            }
        } else {
            if ticketsArray.count > 0 {
                let userTicket = ticketsArray[indexPath.row]
                cell.titleLabel?.text = userTicket.valueForKey("category") as? String
                cell.descriptionLabel?.text = userTicket.valueForKey("ticketDescrption") as? String
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if PFUser.currentUser() == nil {
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }
        
        if indexPath.section == 0 && PFUser.currentUser() != nil {
            print("load the options")
            let ticketSubject = ticketOptionsAry[indexPath.row]
            let vc = storyboard.instantiateViewControllerWithIdentifier("newTicket") as! CreateTicketViewController
            vc.topic = ticketSubject.valueForKey("category") as! String
            vc.topicObjId = ticketSubject.valueForKey("objectId") as! String
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ticketsArray.count > 0 {
            switch section{
                case 1:
                    return "Current tickets"
                default:
                    return "Need help? Select a topic below to get started"
            }
        } else {
            switch section {
            case 1:
                return ""
            default:
                return "Please Login"
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0 {
            if ticketOptionsAry.count > 0 {
                return ticketOptionsAry.count
            } else {
                return 1
            }
        } else {
            if ticketsArray.count > 0 {
                return ticketsArray.count
            } else {
                return 0
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
