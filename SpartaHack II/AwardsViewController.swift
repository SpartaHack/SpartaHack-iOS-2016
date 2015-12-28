//
//  AwardsViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 9/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

/// Controlls the AwardsView
class AwardsViewController: UIViewController {

    @IBOutlet weak var prizesContainerView: UIView!
    @IBOutlet weak var sponsorContainerView: UIView!
    @IBOutlet weak var awardSegmentButton: UISegmentedControl!

    @IBAction func segmentedButtonsTapped(sender: AnyObject) {
        switch awardSegmentButton.selectedSegmentIndex {
        case 0:
        //prizes
            sponsorContainerView.hidden = true
            prizesContainerView.hidden = false
        default:
        //sponsors
            sponsorContainerView.hidden = false
            prizesContainerView.hidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}