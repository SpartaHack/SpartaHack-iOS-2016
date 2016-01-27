//
//  FirstViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData

/* 
    Declaring more than one class in a file is sometimes considered a bit unorthodox
    However, the NewsCell is so closeley related to the NewsCellTableViewController it's worth it. 
*/
class NewsCell: UITableViewCell {
    static let cellIdentifier = "cell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

class NewsTableViewController: UITableViewController, ParseModelDelegate, ParseNewsDelegate, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "News")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let sectionDescriptior = NSSortDescriptor(key: "pinned", ascending: false)
        fetchRequest.sortDescriptors = [sectionDescriptior,sortDescriptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "pinned", cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ParseModel.sharedInstance.newsDelegate = self
        ParseModel.sharedInstance.getNews()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
    }
    
    func fetch (){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        print("make a spinny thing")
        ParseModel.sharedInstance.getNews()
        refreshControl.endRefreshing()
    }
    
    func didGetNewsUpdate() {
        // got more news from parse
        print("\nLOADDING THINGGYS")
        self.fetch()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Pinned Announcements"
        default:
            return "Announcements"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            print("\n Number of objects \(sectionInfo.numberOfObjects) \n")
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    func configureCell (cell: NewsCell, indexPath: NSIndexPath) {
        let news = fetchedResultsController.objectAtIndexPath(indexPath)
        cell.titleLabel?.text = news.valueForKey("title") as? String
        cell.detailLabel?.text = news.valueForKey("newsDescription") as? String
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
                print("New things are better ")
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
            }
            break;
        case .Update:
            print("work here bitch")
            if let indexPath = indexPath {
                let cell = tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
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

