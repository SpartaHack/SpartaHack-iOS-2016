//
//  MentorTicketsTableViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/5/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class MentorTicketTableViewCell: UITableViewCell {
    static let cellIdentifier = "mentorTicketCell"
    @IBOutlet weak var ticketSubjectLabel: UILabel!
    @IBOutlet weak var ticketDescriptionLabel: UILabel!
    @IBOutlet weak var ticketStatusLabel: UILabel!
    @IBOutlet weak var ticketLocationLabel: UILabel!
    @IBOutlet weak var ticketUserNameLabel: UILabel!
}

class MentorTicketsTableViewController: UITableViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.spartaBlack()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70.0
        

    }

    
    func refreshTriggered() {
    }


    func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

        
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Select open ticket to accept"
        default:
            return "Accepted Tickets"
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let view = view as? UITableViewHeaderFooterView {
//            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
//            view.textLabel!.backgroundColor = UIColor.clear
//            view.textLabel!.textColor = UIColor.spartaGreen()
//        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MentorTicketTableViewCell.cellIdentifier, for: indexPath) as! MentorTicketTableViewCell
        return cell
    }
    

}
