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

class HelpDeskTableViewController: UITableViewController, ParseModelDelegate, ParseHelpDeskDelegate, LoginViewControllerDelegate {
    
    var ticketOptionsAry = [NSManagedObject]()
    var ticketsArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ParseModel.sharedInstance.delegate = self
        ParseModel.sharedInstance.helpDeskDelegate = self
        if let currentUser = PFUser.currentUser() {
            // Check to see if a user is logged in, if not, show login view
            print(currentUser)
            ParseModel.sharedInstance.getHelpDeskOptions()
            ParseModel.sharedInstance.getUserTickets()
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.currentUser() != nil{
            self.loadData()
        } else {
            ticketOptionsAry.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func userSuccessfullyLoggedIn(result: Bool) {
        ParseModel.sharedInstance.getHelpDeskOptions()
        ParseModel.sharedInstance.getUserTickets()
    }
    
    func loadData () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TicketSubject")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            ticketOptionsAry = results as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func didGetHelpDeskOptions() {
        self.loadData()
    }
    
    func didGetUserTickets(data: [PFObject]) {
        if data.count != 0 {
            // we have data
            ticketsArray = data
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        } else {
            // we don't have data.... Y?
            fatalError("what the fucking fuck....")
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
                cell.titleLabel?.text = ticketsArray[indexPath.row]["Title"] as? String
                cell.descriptionLabel?.text = ticketsArray[indexPath.row]["description"] as? String
            } else {
                cell.titleLabel?.text = "loading tickets..."
                cell.descriptionLabel?.text = "Please login to use help desk features"
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if PFUser.currentUser() == nil {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            vc.delegate = self
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
            case 1:
                return "Current tickets"
            default:
                return "Need help? Select a topic below to get started"
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
            return 0
//            if ticketsArray.count > 0 {
//                return ticketsArray.count
//            } else {
//                return 0
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
