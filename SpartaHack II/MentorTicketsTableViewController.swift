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

class MentorTicketsTableViewController: UITableViewController, ParseOpenTicketsDelegate {

    var tickets = [NSManagedObject]()
    let helpRefreshControl = UIRefreshControl()
    
    func fetch (){
        tickets.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "MentorTickets")
        let sortDesctiptor = NSSortDescriptor
        fetchRequest.predicate = NSPredicate(format: "status != %@", "Expired")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            tickets = results as! [NSManagedObject]
            print("Open Tickets \(tickets)")
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func didGetOpenTickets() {
        self.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.openTicketDelegate = self
        ParseModel.sharedInstance.getOpenTickets()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        cell.ticketSubjectLabel?.text = tickets[indexPath.row].valueForKey("category") as? String
        cell.ticketDescriptionLabel?.text = tickets[indexPath.row].valueForKey("ticketDescrption") as? String
        cell.ticketStatusLabel.text = tickets[indexPath.row].valueForKey("status") as? String
    }
}
