//
//  AnnouncementsTableViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit

class AnnouncementsTableViewController: SpartaTableViewController  {


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

    override func getDataAndReload() {
        super.isUpdatingData = true
        
        SpartaModel().getAnnouncements(completionHandler: { (success: Bool) in
            if success {
                DispatchQueue.main.async() {
                    // we could do fancy animations here if we wanted
                    super.isUpdatingData = false
                    self.tableView.reloadData()
                }
            } else {
                print("\n\n\n\n **** NETWORK ERROR **** \n\n\n\n")
                super.isUpdatingData = false
            }
        })
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDecelerating(scrollView)
        if refreshControl.isRefreshing {
            getDataAndReload()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
        let announcement: Announcement
        switch indexPath.section {
        // Pinned Style
        case 0:
            announcement =  Announcements.sharedInstance.listOfPinnedAnnouncements()[indexPath.item]
//            Theme.setHorizontalGradient(on: cell.contentView)
        // Normal Announcement
        default:
            announcement =  Announcements.sharedInstance.listOfUnpinnedAnnouncements()[indexPath.item]
        }
        cell.titleLabel.text = announcement.title
        cell.detailLabel.text = announcement.detail
        cell.separatorInset = .zero

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        let sectionTitle: String
        switch section {
        case 0:
            sectionTitle = "Pinned"
//            Theme.setHorizontalGradient(on: headerCell.contentView)
        default:
            sectionTitle = "Announcements"
        }
        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

