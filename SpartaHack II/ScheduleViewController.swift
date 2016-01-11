//
//  ScheduleViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData

class ScheduleCell: UITableViewCell {
    static let cellIdentifier = "eventCell"
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
}

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseScheduleDelegate {

    var eventAry = [NSManagedObject]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.scheduleDelegate = self
        ParseModel.sharedInstance.getSchedule()
    }

    func didGetSchedule() {
        self.loadData()
    }
    
    func loadData () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Event")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            eventAry = results as! [NSManagedObject]
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ScheduleCell.cellIdentifier) as! ScheduleCell
        let event = eventAry[indexPath.row]
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        let dateString = formatter.stringFromDate(event.valueForKey("eventTime") as! NSDate)
        
        cell.eventTitleLabel.text = event.valueForKey("eventTitle") as? String
        cell.eventDescriptionLabel.text = event.valueForKey("eventDescription") as? String
        cell.eventLocationLabel.text = event.valueForKey("eventLocation") as? String
        cell.eventTimeLabel.text = dateString
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventAry.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
