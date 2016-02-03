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

    @IBOutlet var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
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
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        ParseModel.sharedInstance.sponsorDelegate = self
        ParseModel.sharedInstance.getSponsors()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
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
        self.refreshControl.endRefreshing()
    }
    
    func didGetSponsors() {
        self.fetch()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        ParseModel.sharedInstance.getSponsors()
    }

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(SponsorCell.cellIdentifier, forIndexPath: indexPath) as! SponsorCell
        configureCell(cell, indexPath: indexPath)
		return cell
	}
	
    func configureCell(cell: SponsorCell, indexPath: NSIndexPath) {
        let sponsor = fetchedResultsController.objectAtIndexPath(indexPath) as? NSManagedObject
        guard sponsor == nil else {
            cell.sponsorTextLabel.text = ""
            if let imageURL = sponsor!.valueForKey("image") as? String {
                cell.sponsorImageView.sd_setImageWithURL(NSURL(string: imageURL))
            } else {
                cell.sponsorImageView = nil
            }
            cell.contentView.backgroundColor = UIColor.spartaBlack()
            cell.sponsorTextLabel.textColor = UIColor.whiteColor()
            return
        }
    }
	
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            var numLevel = ""
            switch currentSection.name {
            case "1":
                numLevel = "Legend"
                break
            case "2" :
                numLevel = "Commander"
                break
            case "3" :
                numLevel = "Warrior"
                break
            case "4" :
                numLevel = "Trainee"
                break
            default:
                numLevel = "Partner"
                break
            }
            return numLevel
        }
        return""
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
