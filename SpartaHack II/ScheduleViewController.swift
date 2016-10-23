//
//  ScheduleViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var placeholderLabel: UILabel!
}

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))

        let availableBounds = self.view.bounds

        self.tableView.frame = availableBounds
        
        // Then delegate the TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cellNib = UINib(nibName: "ScheduleTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "scheduleCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        // Display table with custom cells
        self.view.addSubview(self.tableView)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.parent?.navigationItem.title = "Schedule"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // TODO: scrolling changes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "scheduleCell") as! ScheduleTableViewCell
        
        cell.placeholderLabel.text = "Schedule Cell blah blah blah"
        cell.placeholderLabel.textColor = UIColor(white: 114/255, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Use real data instead of hardcoded 5.
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // TODO: Chris may want to implement these like last year?
//        switch section{
//        case 0:
//            return "Friday"
//        case 1:
//            return "Saturday"
//        case 2:
//            return "Sunday"
//        default:
//            return "error"
//        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Use real data instead of hardcoded 3.
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
