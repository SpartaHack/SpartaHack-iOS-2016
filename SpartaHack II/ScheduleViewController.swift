//
//  ScheduleViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class ScheduleViewController: SpartaTableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            // qos' default value is ´DispatchQoS.QoSClass.default`
            SpartaModel().getSchedule(completionHandler: { (success: Bool) in
                if success {
                    DispatchQueue.main.async() {
                        // we could do fancy animations here if we wanted
                        self.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    override func getDataAndReload() {
        super.isUpdatingData = true

        SpartaModel().getSchedule(completionHandler: { (success: Bool) in
            if success {
                DispatchQueue.main.async() {
                    // we could do fancy animations here if we wanted
                    super.isUpdatingData = false
                    self.tableView.reloadData()
                }
            }
            else {
                print("\n\n\n\n **** NETWORK ERROR **** \n\n\n\n")
                super.isUpdatingData = false
            }
        })
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDecelerating(scrollView)
        if refreshControl.isRefreshing {
            if !super.isAnimating {
                getDataAndReload()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        
        let cellNib = UINib(nibName: "ScheduleTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "scheduleCell")
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.tableHeaderView?.backgroundColor = Theme.backgroundColor
        self.tableView.tableFooterView?.backgroundColor = Theme.backgroundColor
        self.tableView.backgroundColor = Theme.backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! ScheduleTableViewCell
        let event: Event
        
        event =  Schedule.sharedInstance.listOfEvents()[indexPath.item]
        cell.titleLabel.text = event.title
        cell.detailLabel.text = event.detail
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let eventTimeString = formatter.string(from: event.time as! Date)
        cell.timeLabel.text = eventTimeString
        cell.locationLabel.text = event.location
        cell.separatorInset = .zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        let weekdayInt: Int = Array(Schedule.sharedInstance.weekdayDictionary.keys)[section]
        let sectionTitle = DateFormatter().weekdaySymbols[weekdayInt]
        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.sharedInstance.numberOfWeekdays(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Schedule.sharedInstance.weekdayDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
