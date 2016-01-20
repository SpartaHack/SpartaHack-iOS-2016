//
//  FirstViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse
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

class NewsTableViewController: UITableViewController, ParseModelDelegate, ParseNewsDelegate {
    
    var newsAry = [NSManagedObject]()
    
    var pinnedAry = [NSManagedObject]()
    var unpinnedAry = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ParseModel.sharedInstance.newsDelegate = self
        ParseModel.sharedInstance.getNews()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
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
        self.loadData()
    }
    
    func loadData () {
        print("\nLoading some data\n")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "News")
        unpinnedAry.removeAll()
        pinnedAry.removeAll()
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            newsAry = results as! [NSManagedObject]
            for obj in newsAry {
                if ((obj.valueForKey("pinned") as? Bool) == false) {
                    // not pinned
                    unpinnedAry.append(obj)
                } else {
                    // pinned
                    pinnedAry.append(obj)
                }
            }
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
        // TODO: make a constants file
        let news: NSManagedObject
        
        switch indexPath.section {
        case 0:
            news = pinnedAry[indexPath.row]
        default:
            news = unpinnedAry[indexPath.row]
        }
        
        cell.titleLabel?.text = news.valueForKey("title") as? String
        cell.detailLabel?.text = news.valueForKey("newsDescription") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if pinnedAry.count > 0 {
            switch section{
            case 1:
                return "Announcements"
            default:
                return "Important Announcements"
            }
        } else {
            return "Announcements"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pinnedAry.count
        default:
            return unpinnedAry.count
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

