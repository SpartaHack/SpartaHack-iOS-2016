//
//  MentorTicketsTableViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/5/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData

class MentorTicketTableViewCell: UITableViewCell {
    static let cellIdentifier = "mentorTicketCell"
    @IBOutlet weak var ticketSubjectLabel: UILabel!
    @IBOutlet weak var ticketDescriptionLabel: UILabel!
    @IBOutlet weak var ticketStatusLabel: UILabel!
    @IBOutlet weak var ticketLocationLabel: UILabel!
}

class MentorTicketsTableViewController: UITableViewController, ParseOpenTicketsDelegate, NSFetchedResultsControllerDelegate {

    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "MentorTickets")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "status", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let statusPredicate = NSPredicate(format: "status != %@", "Expired")
        let categoryPredicate = NSPredicate(format: "category == %@", "Mentorship")
        fetchRequest.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [statusPredicate, categoryPredicate])
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "status", cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    let helpRefreshControl = UIRefreshControl()
    
    func fetch (){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.helpRefreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    func didGetOpenTickets() {
        self.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.openTicketDelegate = self
        ParseModel.sharedInstance.getOpenTickets()
        
        helpRefreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(helpRefreshControl)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
    }

    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        ParseModel.sharedInstance.getOpenTickets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MentorTicketTableViewCell.cellIdentifier, forIndexPath: indexPath) as! MentorTicketTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell (cell: MentorTicketTableViewCell, indexPath: NSIndexPath) {
        let ticket = fetchedResultsController.objectAtIndexPath(indexPath)
        cell.ticketSubjectLabel?.text = ticket.valueForKey("category") as? String
        cell.ticketDescriptionLabel?.text = ticket.valueForKey("ticketDescrption") as? String
        cell.ticketStatusLabel.text = ticket.valueForKey("status") as? String
    }
        
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.dequeueReusableCellWithIdentifier(MentorTicketTableViewCell.cellIdentifier) as! MentorTicketTableViewCell
                configureCell(cell, indexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
}
