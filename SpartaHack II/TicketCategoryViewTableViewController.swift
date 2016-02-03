//
//  TicketCategoryViewTableViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/2/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import Parse
import CoreData

class TicketCategoryViewTableViewController: UITableViewController, ParseModelDelegate,ParseHelpDeskDelegate,NSFetchedResultsControllerDelegate{

    var ticketSubjects = [NSManagedObject]()
    let helpRefreshControl = UIRefreshControl()
    
    func fetch (){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TicketSubject")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            ticketSubjects = results as! [NSManagedObject]
            self.tableView.reloadData()
            self.helpRefreshControl.endRefreshing()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        if PFUser.currentUser() != nil {
            ParseModel.sharedInstance.getHelpDeskOptions()
        } else {
            self.helpRefreshControl.endRefreshing()
        }
    }
    
    func didGetHelpDeskOptions() {
        self.fetch()
    }
    
    func didGetUserTickets() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
        
        helpRefreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(helpRefreshControl)
        
        ParseModel.sharedInstance.helpDeskDelegate = self
        ParseModel.sharedInstance.getHelpDeskOptions()

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
        return ticketSubjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(helpDeskCell.cellIdentifier, forIndexPath: indexPath) as! helpDeskCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Category"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewControllerWithIdentifier("newTicket") as! CreateTicketViewController
        vc.topic = ticketSubjects[indexPath.row].valueForKey("category") as! String
        vc.topicObjId = ticketSubjects[indexPath.row].valueForKey("objectId") as! String
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func configureCell (cell: helpDeskCell, indexPath: NSIndexPath) {
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.descriptionLabel.textColor = UIColor.whiteColor()
        cell.statusCell.textColor = UIColor.whiteColor()
        cell.contentView.backgroundColor = UIColor.spartaBlack()
        if PFUser.currentUser() != nil {
            if ticketSubjects.count > 0 {
                let userTicket = ticketSubjects[indexPath.row]
                cell.titleLabel?.text = userTicket.valueForKey("category") as? String
                cell.descriptionLabel?.text = userTicket.valueForKey("ticketSubjectDescription") as? String
                cell.statusCell?.text = ""
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
