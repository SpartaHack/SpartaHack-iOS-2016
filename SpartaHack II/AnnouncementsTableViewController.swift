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
}

class AnnouncementsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var tableView: UITableView = UITableView()
    
    let dummyAnnouncements = [
        ["Covisint Drone Winner", "Congratulations NI Yao; your submission is the winner of Covisnit's Phantom 3 Drone. Thanks for participating! Reach out at hello@spartahack.com to claim :)"],
        ["Buses", "All three buses are here outside the West A Wing! Raid the snack room and have a safe trip home :D"],
        ["UM bus is here!", "Bus to the University of Michigan is here! outside the West A Wing entrance (spartahack.com/map)"],
        ["Closing ceremony!", "Everyone head to B115! Let's give out some prizes :D"],
        ["Top Ten!", "Come to A126: MUSEic, Quizlexa, wake, NutriCam, Employifai, Sir Mix-A-Drink, The Alumi-Moti, We'll Come Back to this Later, Browsvr, Remember"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        
        // TODO: Possilby have the root view controller pass in the rect to use.
        let topHeight: CGFloat = 0.0
        
        var availableBounds = self.view.bounds
        
        availableBounds.size.height -= topHeight
        availableBounds.origin.y += topHeight
        
        self.tableView.frame = availableBounds
        
        // Then delegate the TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cellNib = UINib(nibName: "AnnouncementsTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "announcementsCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        // Display table with custom cells
        self.view.addSubview(self.tableView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.parent?.navigationItem.title = "Announcements"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "announcementsCell") as! AnnouncementsTableViewCell
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.dummyAnnouncements.count)))
        let dummyAnnouncement = self.dummyAnnouncements[randomIndex]
        cell.titleLabel.text = dummyAnnouncement[0]
        cell.detailLabel.text = dummyAnnouncement[1]
        
        return cell
    }
    
    //func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //    let headerView = UIView()
    //    headerView.backgroundColor = Theme.lightGold
    //    return headerView
    //}
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Pinned Announcements"
        default:
            return "Announcements"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
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

