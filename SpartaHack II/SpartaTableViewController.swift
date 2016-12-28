//
//  SpartaTableViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/13/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//


import UIKit

class SpartaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var tableView: UITableView = UITableView()
    var separatorOverride: UIView = UIView()
    private var lastKnownTheme: Int = -1 // set to -1 so the view loads the theme the first time
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        if let tabBar = self.tabBarController {
            self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, tabBar.tabBar.frame.size.height, 0.0)
        }
    }
    
    func needsThemeUpdate() -> Bool {
        return self.lastKnownTheme != Theme.currentTheme()
    }
    
    func updateTheme(animated: Bool = false) {
        self.tableView.tableHeaderView?.backgroundColor = Theme.backgroundColor
        self.tableView.tableFooterView?.backgroundColor = Theme.backgroundColor
        self.tableView.backgroundColor = Theme.backgroundColor
        self.lastKnownTheme = Theme.currentTheme()
        if animated {
            UIView.transition(with: self.tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: nil)
        }
        else {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
        let announcement: Announcement
        switch indexPath.section {
        // Pinned Style
        case 0:
            announcement =  Announcements.sharedInstance.listOfPinnedAnnouncements()[indexPath.item]
            Theme.setHorizontalGradient(of: .lightGradient, on: cell.contentView)
        // Normal Announcement
        default:
            announcement =  Announcements.sharedInstance.listOfUnpinnedAnnouncements()[indexPath.item]
        }
        cell.titleLabel.text = announcement.title
        cell.detailLabel.text = announcement.detail
        cell.separatorInset = .zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        let sectionTitle: String
        switch section {
        case 0:
            sectionTitle = "Pinned"
            Theme.setHorizontalGradient(of: .lightGradient, on: headerCell.contentView)
        default:
            sectionTitle = "Announcements"
        }
        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
