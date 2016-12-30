//
//  PrizesViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/27/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

class PrizesViewController: SpartaTableViewController  {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async {
            // qos' default value is ´DispatchQoS.QoSClass.default`
            SpartaModel().getPrizes(completionHandler: { (success: Bool) in
                if success {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func getDataAndReload() {
        super.isUpdatingData = true
        
        SpartaModel().getPrizes(completionHandler: { (success: Bool) in
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
            if !super.isAnimating {
                getDataAndReload()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        headerCell.separatorInset = .zero
        let sectionTitle: String
        sectionTitle = "Prizes"
        
        headerCell.titleLabel.text = sectionTitle
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Prizes.sharedInstance.listOfPrizes().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
