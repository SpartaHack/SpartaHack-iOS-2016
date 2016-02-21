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
    
    @IBAction func didSwitchViewTapped(sender: AnyObject) {
        switch guideSegmentButton.selectedSegmentIndex {
        case 0:
            // Schedule View Controller
            mapViewControllerContainer.hidden = true
            scheduleViewController.hidden = false
        default:
            // Map View Controller
            mapViewControllerContainer.hidden = false
            scheduleViewController.hidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.spartaBlack()
        guideSegmentButton.tintColor = UIColor.spartaMutedGrey()
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.spartaGreen()], forState: UIControlState.Selected)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}