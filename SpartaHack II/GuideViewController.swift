//
//  GuideViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/25/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit

// Controls the guide view
class GuideViewController: UIViewController {

    @IBOutlet weak var mapViewControllerContainer: UIView!
    @IBOutlet weak var scheduleViewController: UIView!
    @IBOutlet weak var guideSegmentButton: UISegmentedControl!
    
    @IBAction func didSwitchViewTapped(_ sender: AnyObject) {
        switch guideSegmentButton.selectedSegmentIndex {
        case 0:
            // Schedule View Controller
            mapViewControllerContainer.isHidden = true
            scheduleViewController.isHidden = false
        default:
            // Map View Controller
            mapViewControllerContainer.isHidden = false
            scheduleViewController.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.extraLightGold
        // add custom color
        guideSegmentButton.tintColor = Theme.mediumGold
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.spartaGreen()], for: UIControlState.selected)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
