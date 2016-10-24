//
//  ConciergeViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 9/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit


class helpDeskCell: UITableViewCell {
    static let cellIdentifier = "helpCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusCell: UILabel!
    @IBOutlet weak var dividerView: UIView!
}

class HelpDeskTableViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createTicketButton: UIButton!
    
    
    let helpRefreshControl = UIRefreshControl()
    
    
    func refreshTriggered() {

    }
 
    @IBAction func createNewTicketButtonTapped(_ sender: AnyObject) {
    
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
        mainView.backgroundColor = UIColor.spartaBlack()
        
        createTicketButton.backgroundColor = UIColor.spartaBlack()
        createTicketButton.tintColor = UIColor.spartaGreen()
        createTicketButton.layer.borderColor = UIColor.spartaGreen().cgColor
        createTicketButton.layer.cornerRadius = 4
        createTicketButton.layer.borderWidth = 1
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let view = view as? UITableViewHeaderFooterView {
//            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
//            view.textLabel!.backgroundColor = UIColor.clear
//            view.textLabel!.textColor = UIColor.spartaGreen()
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: helpDeskCell.cellIdentifier) as! helpDeskCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
                }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }


   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
