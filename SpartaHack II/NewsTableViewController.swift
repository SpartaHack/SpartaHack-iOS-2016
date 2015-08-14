//
//  FirstViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

/* 
    Declaring more than one class in a file is sometimes considered unorthodox
    
    However, the NewsCell is so closeley related to the NewsCellTableViewController it's worth it.
*/
class NewsCell: UITableViewCell {
    static let cellIdentifier = "cell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

class NewsTableViewController: UITableViewController, ParseModelDelegate {
    
    var dataAry = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ParseModel.sharedInstance.delegate = self
        ParseModel.sharedInstance.getNews()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    override func viewDidAppear(animated: Bool) {
        var currentUser = PFUser.currentUser()
        
        // Check to see if a user is logged in, if not, show login view
        if currentUser == nil {
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
        } else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didGetNewsUpdate(data: [PFObject]) {
        if data.count != 0 {
            // we have data
            dataAry = data
            self.tableView.reloadData()
        } else {
            // we don't have data.... Y?
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(NewsCell.cellIdentifier) as! NewsCell
        cell.titleLabel?.text = dataAry[indexPath.row]["Title"] as? String
        cell.detailLabel?.text = dataAry[indexPath.row]["Description"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
}

