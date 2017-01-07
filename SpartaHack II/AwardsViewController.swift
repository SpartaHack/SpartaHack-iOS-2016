//
//  AwardsViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/4/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import UIKit

/// Controlls the AwardsView
class AwardsViewController: SpartaTableViewController  {
    
    private var currentView = "prizes" // default to prizes view
    private var segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Prizes", "Sponsors"])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataAndReload()
        self.segmentedControl.backgroundColor = Theme.backgroundColor
        self.segmentedControl.tintColor = Theme.primaryColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = self.tableView.frame
        // cropping off 5 pixels from left and right to make it square.
        self.segmentedControl.frame = CGRect(x: frame.origin.x-5, y: frame.origin.y,
                                width: frame.width+10, height: 30)
        self.segmentedControl.addTarget(self, action: #selector(AwardsViewController.segmentedControlValueChanged(segment:)), for: .valueChanged)
        
        // Add optional segmented control
        super.view.addSubview(self.segmentedControl)
        
        self.tableView.frame.origin.y += self.segmentedControl.frame.size.height
        self.tableView.frame.size.height -= self.segmentedControl.frame.size.height
        self.segmentedControl.frame.origin.y += 90
        
        let cellNib = UINib(nibName: "SponsorsTableViewCell", bundle: Bundle(for: type(of: self)))
        self.tableView.register(cellNib, forCellReuseIdentifier: "sponsorCell")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Style the Segmented Control
        self.segmentedControl.layer.cornerRadius = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.segmentedControl.backgroundColor = Theme.backgroundColor
            self.segmentedControl.tintColor = Theme.primaryColor
        })
    }
    
    override func getDataAndReload() {
        super.isUpdatingData = true
        
        switch (currentView) {
            case "prizes":
                SpartaModel.sharedInstance.getPrizes(completionHandler: { (success: Bool) in
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
            case "sponsors":
                SpartaModel.sharedInstance.getSponsors(completionHandler: { (success: Bool) in
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
            default:
                print("Invalid segment selection")
        }
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewWillBeginDecelerating(scrollView)
        if refreshControl.isRefreshing {
            getDataAndReload()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (currentView) {
        case "prizes":
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
            
            let prize = Prizes.sharedInstance.listOfPrizes()[indexPath.row]
            
            cell.titleLabel.text = prize.name
            cell.detailLabel.text = prize.detail
            
            return cell
        case "sponsors":
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "sponsorCell") as! SponsorsTableViewCell
            
            let sponsor = Sponsors.sharedInstance.listOfSponsors()[indexPath.row]
            print("Image to display: \(sponsor.logo)")
            cell.sponsorImageView.image = sponsor.logo
            
            return cell
        default:
            print("Invalid segment selection")
            return self.tableView.dequeueReusableCell(withIdentifier: "spartaCell") as! SpartaTableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (currentView) {
        case "prizes":
            switch section{
            case 0:
                return "SpartaHack Prizes"
            default:
                return "Sponsor Prizes"
            }
        case "sponsors":
            switch section{
            case 0:
                return "SpartaHack Prizes"
            default:
                return "Sponsor Prizes"
            }
        default:
            return "Not implemented"
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (currentView) {
        case "prizes":
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
            headerCell.separatorInset = .zero
            let sectionTitle: String
            sectionTitle = "Prizes"
            
            headerCell.titleLabel.text = sectionTitle
            return headerCell
        case "sponsors":
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
            headerCell.separatorInset = .zero
            let sectionTitle: String
            sectionTitle = "Sponsors"
            
            headerCell.titleLabel.text = sectionTitle
            return headerCell
        default:
            return self.tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SpartaTableViewHeaderCell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (currentView) {
        case "prizes":
            return Prizes.sharedInstance.listOfPrizes().count
        case "sponsors":
            return Sponsors.sharedInstance.listOfSponsors().count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        switch (segment.selectedSegmentIndex) {
        case 0:
            currentView = "prizes"
        case 1:
            currentView = "sponsors"
        default:
            currentView = "prizes"
        }
        getDataAndReload()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

