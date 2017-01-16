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
            SpartaModel.sharedInstance.getSchedule(completionHandler: { (success: Bool) in
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
        
        SpartaModel.sharedInstance.getSchedule(completionHandler: { (success: Bool) in
            if success {
                DispatchQueue.main.async() {
                    // we could do fancy animations here if we wanted
                    super.isUpdatingData = false
                    self.tableView.reloadData()
                }
            } else {
                print("\n\n\n\n **** NETWORK ERROR **** \n\n\n\n")
                SpartaToast.displayError("Failed to load Schedule")
                super.isUpdatingData = false
            }
        })
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDecelerating(scrollView)
        if refreshControl.isRefreshing {
            getDataAndReload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        
        let cellNib = UINib(nibName: "ScheduleTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "scheduleCell")
        
        let countdownNib = UINib(nibName: "CountdownCell", bundle: bundle)
        self.tableView.register(countdownNib, forCellReuseIdentifier: "countdownCell")
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
        
        event =  Schedule.sharedInstance.listOfEventsForSection(indexPath.section-1)[indexPath.item] // -1 because of countdown
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
        switch (section) {
        case 0:
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "countdownCell") as! CountdownCell
            headerCell.separatorInset = .zero
            headerCell.startCountdown()
            return headerCell
        default:
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
            headerCell.separatorInset = .zero
            let sectionTitle = Schedule.sharedInstance.stringForSection(section-1) // -1 because we're putting the countdown at the top
            headerCell.titleLabel.text = sectionTitle
            return headerCell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return Schedule.sharedInstance.listOfEventsForSection(section-1).count // Because of countdown
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Schedule.sharedInstance.weekdayToEventsDictionary.count + 1 // Because of countdown
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0:
            return 75
        default:
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
