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
    @IBOutlet weak var statusCell: UILabel!
}

class HelpDeskTableViewController: UITableViewController, ParseModelDelegate, ParseHelpDeskDelegate, NSFetchedResultsControllerDelegate {
    
    lazy var optionsFetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "TicketSubject")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let optionsFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        optionsFetchedResultsController.delegate = self
        return optionsFetchedResultsController
    }()
    
    lazy var ticketsFetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Ticket")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let statusDescroptor = NSSortDescriptor(key: "status", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor,statusDescroptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let ticketsFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        ticketsFetchedResultsController.delegate = self
        return ticketsFetchedResultsController
    }()
    
    func fetchOptions (){
        do {
            try self.optionsFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        do {
            try self.ticketsFetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        print("make a spinny thing")
        
        if PFUser.currentUser() != nil {
            ParseModel.sharedInstance.getUserTickets()
            ParseModel.sharedInstance.getHelpDeskOptions()
        }
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        ParseModel.sharedInstance.helpDeskDelegate = self
        
        if PFUser.currentUser() != nil {
            ParseModel.sharedInstance.getUserTickets()
            ParseModel.sharedInstance.getHelpDeskOptions()
        }
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
            self.fetchOptions()
            self.tableView.reloadData()
        } else {
            print("")
            print("User is logged out")
            print("")
            self.tableView.reloadData()
        }
    }
    
    func didGetHelpDeskOptions() {
        self.fetchOptions()
    }
    
    func didGetUserTickets() {
        self.fetchOptions()
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(helpDeskCell.cellIdentifier) as! helpDeskCell
        configureCell(cell, indexPath: indexPath)

        return cell
    }
    
    func configureCell (cell: helpDeskCell, indexPath: NSIndexPath) {
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.descriptionLabel.textColor = UIColor.whiteColor()
        cell.statusCell.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.spartaBlack()
        if indexPath.section == 0 {
            if PFUser.currentUser() != nil {
                let ticketSubject = optionsFetchedResultsController.objectAtIndexPath(indexPath)
                cell.titleLabel?.text = ticketSubject.valueForKey("category") as? String
                cell.descriptionLabel?.text = ticketSubject.valueForKey("ticketSubjectDescription") as? String
                cell.statusCell?.text = ""
            } else {
                cell.titleLabel?.text = "Authentication Required"
                cell.descriptionLabel?.text = "Please login to use help desk features"
                cell.statusCell?.text = ""
            }
        } else {
            if PFUser.currentUser() != nil{
                if ticketsFetchedResultsController.sections?[(indexPath.section-1)].numberOfObjects > 0 {
                    let userTicket = ticketsFetchedResultsController.sections?[(indexPath.section-1)].objects?[indexPath.row]
                    cell.titleLabel?.text = userTicket?.valueForKey("category") as? String
                    cell.descriptionLabel?.text = userTicket?.valueForKey("ticketDescrption") as? String
                    cell.statusCell.text = userTicket?.valueForKey("status") as? String
                }
            } else {
                print("Logged out")
            }
        }
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
            let ticketSubject = optionsFetchedResultsController.objectAtIndexPath(indexPath)
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
        if PFUser.currentUser() != nil {
            // check to see if user is logged in or not
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
            if PFUser.currentUser() != nil{
                if let sections = self.optionsFetchedResultsController.sections {
                    let sectionInfo = sections[section]
                    print("Section Info for options \(sectionInfo.numberOfObjects)")
                    return sectionInfo.numberOfObjects
                } else {
                    return 1
                }
            } else {
                return 1
            }
        } else {
            if PFUser.currentUser() != nil {
                if let sections = self.ticketsFetchedResultsController.sections {
                    let sectionInfo = sections[0].numberOfObjects
                    print("Section Info for tickets \(sectionInfo)")
                    return sectionInfo
                } else {
                    return 0
                }
            } else {
                return 0
            }
        }
    }
    
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                print("New things are better ")
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.dequeueReusableCellWithIdentifier(helpDeskCell.cellIdentifier) as! helpDeskCell
                configureCell(cell, indexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
            }
            
            if let newIndexPath = newIndexPath {
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Middle)
            }
            break;
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
