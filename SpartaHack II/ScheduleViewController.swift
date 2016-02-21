//
//  ScheduleViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData
import KILabel
import BOZPongRefreshControl

class ScheduleCell: UITableViewCell {
    static let cellIdentifier = "eventCell"
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: KILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
}

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseScheduleDelegate, NSFetchedResultsControllerDelegate {    
    
    var pongRefreshControl = BOZPongRefreshControl()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Event")
        // Add Sort Descriptors
        let dateDescriptor = NSSortDescriptor(key: "eventDate", ascending: true)
        let timeDescriptor = NSSortDescriptor(key: "eventTime", ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor,timeDescriptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "eventDate", cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.scheduleDelegate = self
        ParseModel.sharedInstance.getSchedule()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        self.tableView.estimatedRowHeight = 70.0
        tableView.backgroundColor = UIColor.spartaBlack()

    }

    func fetch (){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.pongRefreshControl.finishedLoading()
        self.tableView.reloadData()
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
        ParseModel.sharedInstance.getSchedule()
    }

    func didGetSchedule() {
        self.fetch()
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
            view.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            view.textLabel!.numberOfLines = 2
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Friday"
        case 1:
            return "Saturday"
        case 2:
            return "Sunday"
        default:
            return "error"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ScheduleCell.cellIdentifier) as! ScheduleCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell (cell: ScheduleCell, indexPath:NSIndexPath) {
        let event = fetchedResultsController.objectAtIndexPath(indexPath)
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        
        if let eventTime = event.valueForKey("eventTime") as? NSDate {
            cell.eventTimeLabel.text = formatter.stringFromDate(eventTime)
        } else {
            cell.eventTimeLabel.text = ""
        }

        
        cell.eventDescriptionLabel.selectedLinkBackgroundColor = UIColor.spartaGreen()
        cell.eventDescriptionLabel.linkDetectionTypes = KILinkTypeOption.URL
        cell.eventDescriptionLabel.urlLinkTapHandler = { label, url, range in
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
        
        cell.eventTitleLabel.textColor = UIColor.whiteColor()
        cell.eventDescriptionLabel.textColor = UIColor.whiteColor()
        cell.eventLocationLabel.textColor = UIColor.whiteColor()
        cell.eventTimeLabel.textColor = UIColor.whiteColor()
        
        cell.contentView.backgroundColor = UIColor.spartaBlack()
        
        cell.eventTitleLabel.text = event.valueForKey("eventTitle") as? String
        cell.eventDescriptionLabel.text = event.valueForKey("eventDescription") as? String
        cell.eventLocationLabel.text = event.valueForKey("eventLocation") as? String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.dequeueReusableCellWithIdentifier(ScheduleCell.cellIdentifier) as! ScheduleCell
                configureCell(cell, indexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
