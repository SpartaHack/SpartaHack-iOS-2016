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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
        let event: Event
        
        // ToDo: use different sections for different days
        event =  Schedule.sharedInstance.listOfEvents()[indexPath.item]
//        Theme.setHorizontalGradient(of: .lightGradient, on: cell.contentView)
        cell.titleLabel.text = event.title
        cell.detailLabel.text = event.detail
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
