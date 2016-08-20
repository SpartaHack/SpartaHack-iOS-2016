//
//  FirstViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit
import KILabel
import MessageUI
import BOZPongRefreshControl

/* 
    Declaring more than one class in a file is sometimes considered a bit unorthodox
    However, the NewsCell is so closeley related to the NewsCellTableViewController it's worth it. 
*/
class NewsCell: UITableViewCell {
    static let cellIdentifier = "cell"
    @IBOutlet weak var titleLabel: SpartaLabel!
    @IBOutlet weak var detailLabel: KILabel!

}

class NewsTableViewController: UITableViewController  {

    var pongRefreshControl = BOZPongRefreshControl()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        self.tableView.backgroundColor = UIColor.spartaBlack()
        
    }
    
    override func viewDidLayoutSubviews() {
//        self.pongRefreshControl = BOZPongRefreshControl.attach(to: self.tableView, withRefreshTarget: self, andRefreshAction: #selector(NewsTableViewController.refreshTriggered))
        self.pongRefreshControl.backgroundColor = UIColor.spartaBlack()
        self.pongRefreshControl.foregroundColor = UIColor.spartaGreen()

    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pongRefreshControl.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pongRefreshControl.scrollViewDidEndDragging()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)       
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellIdentifier) as! NewsCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: "Moondance", size: headerFontSize)
            view.textLabel!.backgroundColor = UIColor.clear
            view.textLabel!.textColor = UIColor.spartaGreen()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Pinned Announcements"
        default:
            return "Announcements"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }
    


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -
    // MARK: Fetched Results Controller Delegate Methods
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

