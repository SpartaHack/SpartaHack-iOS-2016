//
//  AnnouncementsTableViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit

class AnnouncementsTableViewCell: UITableViewCell {
    @IBOutlet weak var placeholderLabel: UILabel!
}

class AnnouncementsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        
        // TODO: Possilby have the root view controller pass in the rect to use.
        let topHeight: CGFloat = 50.0
        
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "announcementsCell") as! AnnouncementsTableViewCell
        
        cell.placeholderLabel.text = "Announcements Cell blah blah blah"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
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

