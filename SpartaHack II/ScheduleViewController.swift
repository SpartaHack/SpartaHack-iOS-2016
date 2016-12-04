//
//  ScheduleViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView = UITableView()
    
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
        
        let bundle = Bundle(for: type(of: self))
        
        let availableBounds = self.view.bounds
        
        self.tableView.frame = availableBounds
        
        self.tableView.separatorStyle = .none
        
        // Then delegate the TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cellNib = UINib(nibName: "SpartaTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "spartaCell")
        
        let headerNib = UINib(nibName: "SpartaTableViewHeaderCell", bundle: bundle)
        self.tableView.register(headerNib, forCellReuseIdentifier: "headerCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        self.tableView.allowsSelection = false
        
        // Display table with custom cells
        self.view.addSubview(self.tableView)
        
        // ToDo: Subclass and make a SpartaViewController that sets this.
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.tabBarController!.tabBar.frame.size.height, 0.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        let sectionTitle: String
        sectionTitle = "Schedule"

        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Schedule.sharedInstance.listOfEvents().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
