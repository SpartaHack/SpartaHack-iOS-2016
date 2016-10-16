//
//  TicketCategoryViewTableViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/2/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class TicketCategoryViewTableViewController: UITableViewController {

    let helpRefreshControl = UIRefreshControl()

    
    func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = UIColor.spartaBlack()
        
        helpRefreshControl.addTarget(self, action: #selector(TicketCategoryViewTableViewController.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(helpRefreshControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: helpDeskCell.cellIdentifier, for: indexPath) as! helpDeskCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let view = view as? UITableViewHeaderFooterView {
//            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
//            view.textLabel!.backgroundColor = UIColor.clear
//            view.textLabel!.textColor = UIColor.spartaGreen()
//        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select Category"
    }
    
    
    
}
