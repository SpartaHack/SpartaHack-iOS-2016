//
//  ConciergeViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 9/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

class helpDeskCell: UITableViewCell {
    static let cellIdentifier = "helpCell"
    let loginCell = true
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}

class HelpDeskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ParseModelDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var dataAry = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ParseModel.sharedInstance.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        if let currentUser = PFUser.currentUser() {
            // Check to see if a user is logged in, if not, show login view
            print(currentUser)
            ParseModel.sharedInstance.getHelpDeskOptions()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if PFUser.currentUser() != nil {
            ParseModel.sharedInstance.getHelpDeskOptions()
        }
    }
    
    func didGetHelpDeskOptions(data: [PFObject]) {
        if data.count != 0 {
            // we have data
            dataAry = data
            self.tableView.reloadData()
        } else {
            // we don't have data.... Y?
            fatalError("what the fucking fuck....")
        }
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(helpDeskCell.cellIdentifier) as! helpDeskCell
        
        if indexPath.section == 0 {
            if dataAry.count > 0 {
                cell.titleLabel?.text = dataAry[indexPath.row]["Title"] as? String
                cell.descriptionLabel?.text = dataAry[indexPath.row]["Description"] as? String
            } else {
                cell.titleLabel?.text = "Authentication Required"
                cell.descriptionLabel?.text = "Please login to use help desk features"
            }
        } else {
            cell.titleLabel?.text = "Sample Ticket"
            cell.descriptionLabel?.text = "Sample Description"
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if PFUser.currentUser() == nil {
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
            case 1:
                return "Current tickets"
            default:
                return "Need help? Select a topic below to get started"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0 {
            if dataAry.count > 0 {
                return dataAry.count
            } else {
                return 1
            }
        } else {
            return 10
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
