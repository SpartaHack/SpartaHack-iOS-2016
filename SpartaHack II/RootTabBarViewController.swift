//
//  RootTabBarViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 1/7/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

let headerFontSize:CGFloat = 20;

class RootTabBarViewController: UITabBarController {

    @IBOutlet weak var mentorButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.spartaGreen()
        self.tabBar.backgroundColor = UIColor.spartaBlack()
        self.tabBar.barTintColor = UIColor.spartaBlack()
        
        mentorButton.isEnabled = false
        mentorButton.tintColor = UIColor.spartaBlack()
        
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Moondance", size: 20)!, NSForegroundColorAttributeName: UIColor.spartaGreen()], for: UIControlState())
        
        
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 440,height: 44))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Moondance", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.text = "< SPARTAHACK />"
        self.navigationController?.navigationBar.topItem?.titleView = label

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileButtonTapped(_ sender: AnyObject) {
            }

    
    @IBAction func mentorshipButtonTapped(_ sender: AnyObject) {
        }
}
