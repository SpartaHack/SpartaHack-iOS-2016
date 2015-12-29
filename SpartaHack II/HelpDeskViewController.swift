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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let currentUser = PFUser.currentUser() {
            // Check to see if a user is logged in, if not, show login view
            print(currentUser)
            ParseModel.sharedInstance.getHelpDeskOptions()
        } else {
            // TODO: make a constants file
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
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
        cell.titleLabel?.text = dataAry[indexPath.row]["Title"] as? String
        cell.descriptionLabel?.text = dataAry[indexPath.row]["Description"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
