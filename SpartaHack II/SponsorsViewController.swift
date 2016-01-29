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

class SponsorCell: UITableViewCell {
	static let cellIdentifier = "sponsorCell"
	@IBOutlet var sponsorImageView: UIImageView!
	@IBOutlet var sponsorTextLabel: UILabel!
}


class SponsorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseModelDelegate, ParseSponsorDelegate, NSFetchedResultsControllerDelegate{

    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Sponsor")
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

	@IBOutlet var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        ParseModel.sharedInstance.sponsorDelegate = self
        ParseModel.sharedInstance.getSponsors()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        // Do any additional setup after loading the view.
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
    
    func didGetSponsors() {
        self.fetch()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        print("make a spinny thing")
        ParseModel.sharedInstance.getSponsors()
        refreshControl.endRefreshing()
    }

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(SponsorCell.cellIdentifier, forIndexPath: indexPath) as! SponsorCell
        configureCell(cell, indexPath: indexPath)
		return cell
	}
	
    func configureCell(cell: SponsorCell, indexPath: NSIndexPath) {
        let sponsor = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject
        guard sponsor == nil else {
            cell.sponsorTextLabel.text = sponsor!.valueForKey("name") as? String
            cell.sponsorImageView.sd_setImageWithURL(NSURL(string: sponsor!.valueForKey("image") as! String))
            print("image ID \(sponsor!.valueForKey("image"))")
            return
        }
        
        
        
//        if let imageLink = sponsor.valueForKey("image") as? String {
////            cell.sponsorImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: image)!)!)
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
//                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageLink)!)!)
//                dispatch_async(dispatch_get_main_queue()) {
//                    cell.sponsorImageView.image = image;
//                }
//            }
//        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
