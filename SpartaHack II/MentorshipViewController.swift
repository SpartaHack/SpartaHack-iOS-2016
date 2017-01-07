//
//  MentorshipViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/16/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class MentorshipViewController: SpartaTableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 350
        self.tableView.alwaysBounceVertical = false // disable scrolling
        let mentorFormNib = UINib(nibName: "MentorFormCell", bundle: Bundle(for: type(of: self)))
        self.tableView.register(mentorFormNib, forCellReuseIdentifier: "mentorFormCell")
        self.hideKeyboard()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "mentorFormCell") as! MentorFormCell

        cell.separatorInset = .zero
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        headerCell.titleLabel.text = "Create A Ticket"
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func requiresLogin() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
