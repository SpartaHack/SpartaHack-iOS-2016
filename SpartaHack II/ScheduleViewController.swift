//
//  ScheduleViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import KILabel
import BOZPongRefreshControl

class ScheduleCell: UITableViewCell {
    static let cellIdentifier = "eventCell"
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: KILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
}

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pongRefreshControl = BOZPongRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        self.tableView.estimatedRowHeight = 70.0
        tableView.backgroundColor = UIColor.spartaBlack()

    }

    
    override func viewDidLayoutSubviews() {
        
        self.pongRefreshControl.backgroundColor = UIColor.spartaBlack()
        self.pongRefreshControl.foregroundColor = UIColor.spartaGreen()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pongRefreshControl.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pongRefreshControl.scrollViewDidEndDragging()
    }
    



    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clear
            view.textLabel!.textColor = UIColor.spartaGreen()
            view.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
            view.textLabel!.numberOfLines = 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Friday"
        case 1:
            return "Saturday"
        case 2:
            return "Sunday"
        default:
            return "error"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.cellIdentifier) as! ScheduleCell
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
