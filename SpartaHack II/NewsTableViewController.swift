//
//  FirstViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData
import KILabel
import MessageUI
import Parse
import BOZPongRefreshControl

/* 
    Declaring more than one class in a file is sometimes considered a bit unorthodox
    However, the NewsCell is so closeley related to the NewsCellTableViewController it's worth it. 
*/
class NewsCell: UITableViewCell {
    static let cellIdentifier = "cell"
    @IBOutlet weak var titleLabel: SpartaLabel!
    @IBOutlet weak var detailLabel: KILabel!

}

class NewsTableViewController: UITableViewController, ParseModelDelegate, ParseNewsDelegate, NSFetchedResultsControllerDelegate {

    var pongRefreshControl = BOZPongRefreshControl()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "News")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let sectionDescriptior = NSSortDescriptor(key: "pinned", ascending: false)
        fetchRequest.sortDescriptors = [sectionDescriptior,sortDescriptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "pinned", cacheName: nil)
        // Configure Fetched Results Controller
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ParseModel.sharedInstance.newsDelegate = self
        ParseModel.sharedInstance.getNews()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        self.tableView.backgroundColor = UIColor.spartaBlack()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.pongRefreshControl = BOZPongRefreshControl.attachToScrollView(self.tableView, withRefreshTarget: self, andRefreshAction: "refreshTriggered")
        self.pongRefreshControl.backgroundColor = UIColor.spartaBlack()
        self.pongRefreshControl.foregroundColor = UIColor.spartaGreen()

    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.pongRefreshControl.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pongRefreshControl.scrollViewDidEndDragging()
    }
    
    func refreshTriggered() {
        ParseModel.sharedInstance.getNews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let install = PFInstallation.currentInstallation()
        install.badge = 0
        install.saveEventually()
       
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
    
    func didGetNewsUpdate() {
        // got more news from parse
        self.fetch()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
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
        cell.backgroundColor = UIColor.spartaBlack()
        
        cell.detailLabel.textColor = UIColor.whiteColor()
        cell.detailLabel.selectedLinkBackgroundColor = UIColor.spartaGreen()
        cell.detailLabel.linkDetectionTypes = KILinkTypeOption.URL
        
        cell.detailLabel.urlLinkTapHandler = { label, url, range in
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        }
        
        ///Set colors
//        cell.titleLabel.textColor = UIColor.whiteColor()
//        cell.titleLabel.backgroundColor = UIColor.spartaBlack()
        cell.detailLabel.backgroundColor = UIColor.spartaBlack()
        cell.contentView.backgroundColor = UIColor.spartaBlack()
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
    
    func controller(
        controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            switch type {
            case NSFetchedResultsChangeType.Insert:
                if let insertIndexPath = newIndexPath {
                    self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            case NSFetchedResultsChangeType.Delete:
                if let deleteIndexPath = indexPath {
                    self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            case NSFetchedResultsChangeType.Update:
                if let updateIndexPath = indexPath {
                    let cell = self.tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
                    configureCell(cell, indexPath: updateIndexPath)
                }
            case NSFetchedResultsChangeType.Move:
                if let deleteIndexPath = indexPath {
                    self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                
                if let insertIndexPath = newIndexPath {
                    self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
    }
    
    func controller(
        controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                let sectionIndexSet = NSIndexSet(index: sectionIndex)
                self.tableView.insertSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            case .Delete:
                let sectionIndexSet = NSIndexSet(index: sectionIndex)
                self.tableView.deleteSections(sectionIndexSet, withRowAnimation: UITableViewRowAnimation.Fade)
            default:
                ""
            }
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

