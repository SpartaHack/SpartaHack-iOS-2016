//
//  PrizesViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/27/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData

class PrizeCell: UITableViewCell {
    static let cellIdentifier = "prizeCell"
    @IBOutlet weak var prizeNameLabel: UILabel!
    @IBOutlet weak var prizeDescriptionLabel: UILabel!
    @IBOutlet weak var prizesSponsorLabel: UILabel!
}

class PrizesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParsePrizesDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!    
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Prize")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        ParseModel.sharedInstance.prizeDelegate = self
        ParseModel.sharedInstance.getPrizes()
        self.fetch()
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.backgroundColor = UIColor.spartaBlack()
    }
    
    func didGetPrizes() {
        self.fetch()
    }
    
    func fetch (){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        print("make a spinny thing")
        ParseModel.sharedInstance.getSchedule()
        refreshControl.endRefreshing()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PrizeCell.cellIdentifier) as! PrizeCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell (cell: PrizeCell, indexPath: NSIndexPath) {
        let prize = fetchedResultsController.objectAtIndexPath(indexPath)
        cell.prizeNameLabel.text = prize.valueForKey("name") as? String
        cell.prizeDescriptionLabel.text = prize.valueForKey("prizeDescription") as? String
        cell.prizesSponsorLabel.text = "Sponsored by \(prize.valueForKey("sponsor") as! String)"
        
        cell.prizeNameLabel.textColor = UIColor.whiteColor()
        cell.prizeDescriptionLabel.textColor = UIColor.whiteColor()
        cell.prizesSponsorLabel.textColor = UIColor.spartaGreen()
        
        cell.contentView.backgroundColor = UIColor.spartaBlack()
        
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
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            print("work here bitch")
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! PrizeCell
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
