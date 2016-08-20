//
//  PrizesViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/27/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import BOZPongRefreshControl

class PrizeCell: UITableViewCell {
    static let cellIdentifier = "prizeCell"
    @IBOutlet weak var prizeNameLabel: UILabel!
    @IBOutlet weak var prizeDescriptionLabel: UILabel!
    @IBOutlet weak var prizesSponsorLabel: UILabel!
}

class PrizesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!    
    
    var pongRefreshControl = BOZPongRefreshControl()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        // Do any additional setup after loading the view.
        tableView.backgroundColor = UIColor.spartaBlack()
    }

    override func viewDidLayoutSubviews() {
        self.pongRefreshControl = BOZPongRefreshControl.attach(to: self.tableView, withRefreshTarget: self, andRefreshAction: #selector(PrizesViewController.refreshTriggered))
        self.pongRefreshControl.backgroundColor = UIColor.spartaBlack()
        self.pongRefreshControl.foregroundColor = UIColor.spartaGreen()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pongRefreshControl.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pongRefreshControl.scrollViewDidEndDragging()
    }
    
    func refreshTriggered() {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrizeCell.cellIdentifier) as! PrizeCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clear
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "SpartaHack Prizes"
        default:
            return "Sponsored Prizes"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
