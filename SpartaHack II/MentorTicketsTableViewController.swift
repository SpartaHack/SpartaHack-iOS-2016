//
//  MentorTicketsTableViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/5/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData
import Parse

class MentorTicketTableViewCell: UITableViewCell {
    static let cellIdentifier = "mentorTicketCell"
    @IBOutlet weak var ticketSubjectLabel: UILabel!
    @IBOutlet weak var ticketDescriptionLabel: UILabel!
    @IBOutlet weak var ticketStatusLabel: UILabel!
    @IBOutlet weak var ticketLocationLabel: UILabel!
}

class MentorTicketsTableViewController: UITableViewController, ParseOpenTicketsDelegate, NSFetchedResultsControllerDelegate {

    var tickets = [NSManagedObject]()
    let helpRefreshControl = UIRefreshControl()
    
    func fetch (){
        tickets.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MentorTickets")
        
        let statusPredicate = NSPredicate(format: "status != %@", "Expired")
        let deletedPredicate = NSPredicate(format: "status != %@", "Deleted")
        let categoryPredicate = NSPredicate(format: "category == %@", "Mentorship")
        let openPredicate = NSPredicate(format: "mentorId == %@ || mentorId == %@","", (PFUser.currentUser()?.objectId!)!) // open ticket with no mentor assigned
//        let acceptedPredicate = NSPredicate(format: "mentorId == %@", (PFUser.currentUser()?.objectId!)!)
        fetchRequest.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [statusPredicate, deletedPredicate, categoryPredicate, openPredicate])
        
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let statusDescriptor = NSSortDescriptor(key: "statusNum", ascending: true)
        
        fetchRequest.sortDescriptors = [statusDescriptor,sortDescriptor]
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            tickets = results as! [NSManagedObject]
            self.tableView.reloadData()
            self.helpRefreshControl.endRefreshing()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
    
    func didGetOpenTickets() {
        self.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpRefreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(helpRefreshControl)
        
        tableView.backgroundColor = UIColor.spartaBlack()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
        
        ParseModel.sharedInstance.openTicketDelegate = self
        ParseModel.sharedInstance.getOpenTickets()
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let ticket = tickets[indexPath.row]
        ParseModel.sharedInstance.extendTicket(ticket.valueForKey("objectId") as! String, status: "Accepted")
        ParseModel.sharedInstance.getOpenTickets()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "<Select open ticket to accept/>"
        default:
            return "<Accepted Tickets>"
        }
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MentorTicketTableViewCell.cellIdentifier, forIndexPath: indexPath) as! MentorTicketTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell (cell: MentorTicketTableViewCell, indexPath: NSIndexPath) {
        let ticket = tickets[indexPath.row]
        cell.ticketSubjectLabel?.text = ticket.valueForKey("category") as? String
        cell.ticketDescriptionLabel?.text = ticket.valueForKey("ticketDescrption") as? String
        cell.ticketStatusLabel.text = ticket.valueForKey("status") as? String
        cell.ticketLocationLabel.text = ticket.valueForKey("location") as? String
        
        print("Assigned Mentor \(tickets[indexPath.row].valueForKey("mentorId"))")
        
        cell.ticketSubjectLabel.textColor = UIColor.whiteColor()
        cell.ticketDescriptionLabel.textColor = UIColor.whiteColor()
        cell.ticketLocationLabel.textColor = UIColor.whiteColor()
        cell.ticketStatusLabel.textColor = UIColor.whiteColor()
        
        cell.contentView.backgroundColor = UIColor.spartaBlack()
    }
}
