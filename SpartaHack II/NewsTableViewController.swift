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

class NewsTableViewController: UITableViewController, ParseModelDelegate {
    
    var newsAry = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ParseModel.sharedInstance.delegate = self
        ParseModel.sharedInstance.getNews()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func didGetNewsUpdate() {
        // got more news from parse
        self.loadData()
    }
    
    func loadData () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "News")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            newsAry = results as! [NSManagedObject]
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
        // TODO: make a constants file
        let news = newsAry[indexPath.row]
        cell.titleLabel?.text = news.valueForKey("title") as? String
        cell.detailLabel?.text = news.valueForKey("newsDescription") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsAry.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

