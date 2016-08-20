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

    @IBAction func segmentedButtonsTapped(_ sender: AnyObject) {
        switch awardSegmentButton.selectedSegmentIndex {
        case 0:
        //prizes
            sponsorContainerView.isHidden = true
            prizesContainerView.isHidden = false
        default:
        //sponsors
            sponsorContainerView.isHidden = false
            prizesContainerView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.spartaBlack()
        // custom colors
        awardSegmentButton.tintColor = UIColor.spartaMutedGrey()
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.spartaGreen()], for: UIControlState.selected)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
