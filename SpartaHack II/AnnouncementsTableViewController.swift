//
//  AnnouncementsTableViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit

class AnnouncementsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: SpartaLabel!
    @IBOutlet weak var detailLabel: SpartaLabel!
    @IBOutlet weak var barView: UIView!
    override func layoutSubviews() {
        barView.backgroundColor = Theme.darkGold
    }
}
class AnnouncementsTableViewHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: SpartaLabel!
}

class AnnouncementsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var tableView: UITableView = UITableView()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            // qos' default value is ´DispatchQoS.QoSClass.default`
            SpartaModel().getAnnouncements(completionHandler: { (success: Bool) in
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
        
        let cellNib = UINib(nibName: "AnnouncementsTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "announcementsCell")
        
        let headerNib = UINib(nibName: "AnnouncementsTableViewHeaderCell", bundle: bundle)
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
        self.parent?.navigationItem.title = "Announcements"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "announcementsCell") as! AnnouncementsTableViewCell
        let announcement: Announcement
        switch indexPath.section {
        case 0:
            announcement =  Announcements.sharedInstance.listOfPinnedAnnouncements()[indexPath.item]
        default:
            announcement =  Announcements.sharedInstance.listOfUnpinnedAnnouncements()[indexPath.item]
        }
        cell.titleLabel.text = announcement.title
        cell.detailLabel.text = announcement.detail

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! AnnouncementsTableViewHeaderCell

        Theme.setGradient(of: .lightGradient, on: headerCell.contentView)
        
        let sectionTitle: String
        switch section {
        case 0:
            sectionTitle = "Pinned"
        default:
            sectionTitle = "Announcements"
        }
        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Announcements.sharedInstance.listOfPinnedAnnouncements().count
        case 1:
            return Announcements.sharedInstance.listOfUnpinnedAnnouncements().count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

