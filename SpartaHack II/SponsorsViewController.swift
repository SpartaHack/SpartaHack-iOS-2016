//
//  SponsorsViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/27/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import BOZPongRefreshControl

class SponsorCell: UITableViewCell {
	static let cellIdentifier = "sponsorCell"
	@IBOutlet var sponsorImageView: UIImageView!
}

class SponsorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseModelDelegate, ParseSponsorDelegate, NSFetchedResultsControllerDelegate{

    @IBOutlet var tableView: UITableView!
    var pongRefreshControl = BOZPongRefreshControl()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Sponsor")
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "tier", ascending: true)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor,nameDescriptor]
        // Initialize Fetched Results Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.managedObjectContext, sectionNameKeyPath: "tier", cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ParseModel.sharedInstance.sponsorDelegate = self
        ParseModel.sharedInstance.getSponsors()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
        // Do any additional setup after loading the view.
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
        ParseModel.sharedInstance.getSponsors()
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
    
    func didGetSponsors() {
        self.fetch()
    }
    

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(SponsorCell.cellIdentifier, forIndexPath: indexPath) as! SponsorCell
        configureCell(cell, indexPath: indexPath)
		return cell
	}
	
    func configureCell(cell: SponsorCell, indexPath: NSIndexPath) {
        let sponsor = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject
        guard sponsor == nil else {
            if let imageURL = sponsor!.valueForKey("image") as? String {
                cell.sponsorImageView.sd_setImageWithURL((NSURL(string: imageURL)), placeholderImage: UIImage(named: "loading"), options: SDWebImageOptions.ContinueInBackground)
            } else {
                cell.sponsorImageView = nil
            }
            cell.contentView.backgroundColor = UIColor.spartaBlack()
            return
        }
    }
	
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1 :
            return 85
        case 2 :
            return 65
        case 3 :
            return 55
        default:
            return 100
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SponsorCell {
                    configureCell(cell, indexPath: indexPath)
                }
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
}
