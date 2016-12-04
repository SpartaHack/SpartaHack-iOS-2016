//
//  PrizesViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/27/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class PrizesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        
        let availableBounds = self.view.bounds
        
        self.tableView.frame = availableBounds
        
        // Then delegate the TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let cellNib = UINib(nibName: "SpartaTableViewCell", bundle: bundle)
        self.tableView.register(cellNib, forCellReuseIdentifier: "spartaCell")
        
        let headerNib = UINib(nibName: "SpartaTableViewHeaderCell", bundle: bundle)
        self.tableView.register(headerNib, forCellReuseIdentifier: "headerCell")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 140
        
        // Display table with custom cells
        self.view.addSubview(self.tableView)
        
        // ToDo: Subclass and make a SpartaViewController that sets this.
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.tabBarController!.tabBar.frame.size.height, 0.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.parent?.navigationItem.title = "Prizes"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
        
        let prize = Prizes.sharedInstance.listOfPrizes()[indexPath.row]
        
        cell.titleLabel.text = prize.name
        cell.detailLabel.text = prize.detail
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "SpartaHack Prizes"
        default:
            return "Sponsor Prizes"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        let sectionTitle: String
        sectionTitle = "Prizes"
        
        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Prizes.sharedInstance.listOfPrizes().count
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
