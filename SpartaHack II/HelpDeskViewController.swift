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
import BOZPongRefreshControl


class helpDeskCell: UITableViewCell {
    static let cellIdentifier = "helpCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusCell: UILabel!
    @IBOutlet weak var dividerView: UIView!
}

class HelpDeskTableViewController: UIViewController, ParseModelDelegate, ParseHelpDeskDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createTicketButton: UIButton!
    
    var pongRefreshControl = BOZPongRefreshControl()
    
    var tickets = [NSManagedObject]()
    var ticketSubjects = [NSManagedObject]()
    let helpRefreshControl = UIRefreshControl()
    
    
    func fetchCategories (){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TicketSubject")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            ticketSubjects = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    
    func fetch (){
        tickets.removeAll()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Ticket")
        
        let statusPredicate = NSPredicate(format: "status != %@", "Deleted")
        fetchRequest.predicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates: [statusPredicate])
        
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        let statusDescriptor = NSSortDescriptor(key: "statusNum", ascending: true)
        
        fetchRequest.sortDescriptors = [statusDescriptor,sortDescriptor]
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            tickets = results as! [NSManagedObject]
            self.pongRefreshControl.finishedLoading()
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.pongRefreshControl = BOZPongRefreshControl.attachToScrollView(self.tableView, withRefreshTarget: self, andRefreshAction: "refreshTriggered")
        self.pongRefreshControl.backgroundColor = UIColor.spartaBlack()
        self.pongRefreshControl.foregroundColor = UIColor.spartaGreen()
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.pongRefreshControl.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pongRefreshControl.scrollViewDidEndDragging()
    }
    
    func refreshTriggered() {
        if PFUser.currentUser() != nil {
            ParseModel.sharedInstance.getUserTickets()
        } else {
            self.pongRefreshControl.finishedLoading()
        }
    }
 
    @IBAction func createNewTicketButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if PFUser.currentUser() == nil {
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        } else {
            let vc = storyboard.instantiateViewControllerWithIdentifier("newTicket") as! CreateTicketViewController
            vc.topic = ticketSubjects[0].valueForKey("category") as! String
            vc.topicObjId = ticketSubjects[0].valueForKey("objectId") as! String
            vc.listOfOptions = ticketSubjects[0].valueForKey("subCategory") as! NSData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            tickets.removeAll()
            fetch()
        } else {
            ParseModel.sharedInstance.helpDeskDelegate = self
            ParseModel.sharedInstance.getHelpDeskOptions()
            fetch()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
        mainView.backgroundColor = UIColor.spartaBlack()
        
        ParseModel.sharedInstance.helpDeskDelegate = self
        ParseModel.sharedInstance.getHelpDeskOptions()
        
        if PFUser.currentUser() != nil {
            ParseModel.sharedInstance.getUserTickets()
        }
        
        createTicketButton.backgroundColor = UIColor.spartaBlack()
        createTicketButton.tintColor = UIColor.spartaGreen()
        createTicketButton.layer.borderColor = UIColor.spartaGreen().CGColor
        createTicketButton.layer.cornerRadius = 4
        createTicketButton.layer.borderWidth = 1
    }
    
    func didGetHelpDeskOptions() {
        self.fetchCategories()
    }
    
    func didGetUserTickets() {
        self.fetch()
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(helpDeskCell.cellIdentifier) as! helpDeskCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell (cell: helpDeskCell, indexPath: NSIndexPath) {
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.descriptionLabel.textColor = UIColor.whiteColor()
        cell.statusCell.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.spartaBlack()
        if PFUser.currentUser() != nil {
            if tickets.count > 0 {
                let userTicket = tickets[indexPath.row]
                cell.titleLabel?.text = userTicket.valueForKey("category") as? String
                cell.descriptionLabel?.text = userTicket.valueForKey("ticketDescrption") as? String
                cell.statusCell.text = userTicket.valueForKey("status") as? String
                cell.dividerView.backgroundColor = UIColor.whiteColor()
            }
        } else {
            cell.dividerView.backgroundColor = UIColor.spartaBlack()
            cell.titleLabel?.text = "Authentication Required"
            cell.descriptionLabel?.text = "Please login to use help desk features"
            cell.statusCell?.text = ""
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if PFUser.currentUser() == nil {
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginView") as! LoginViewController
            self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        } else {
            let ticketStatus = tickets[indexPath.row].valueForKey("status") as! String
            if  ticketStatus == "Expired" {
                let alert = UIAlertController(title: "", message: "Reopen Ticket?", preferredStyle: .ActionSheet)
                let extend = UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) -> Void in
                    ParseModel.sharedInstance.extendTicket(self.tickets[indexPath.row].valueForKey("objectId") as! String, status: "Open")
                    ParseModel.sharedInstance.getUserTickets()
                })
                let cancel = UIAlertAction(title: "No", style: .Cancel, handler: nil)
                alert.addAction(extend)
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                ParseModel.sharedInstance.extendTicket(tickets[indexPath.row].valueForKey("objectId") as! String, status: "Deleted")
                ParseModel.sharedInstance.getUserTickets()
                self.tickets.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if PFUser.currentUser() != nil {
            // check to see if user is logged in or not
            return "Your Tickets"
        } else {
            return "Please Login"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if PFUser.currentUser() != nil {
            return tickets.count
        } else {
            return 1
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
