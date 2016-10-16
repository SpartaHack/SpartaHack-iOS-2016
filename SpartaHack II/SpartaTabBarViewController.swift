//
//  SpartaTabBarViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 10/6/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class SpartaTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Arial", size: 20)!, NSForegroundColorAttributeName: Theme.darkBrown], for: UIControlState())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = AnnouncementsTableViewController()
        let icon1 = UITabBarItem(title: "Announcements", image: nil, selectedImage: nil)
        item1.tabBarItem = icon1
        
        let item2 = ScheduleViewController()
        let icon2 = UITabBarItem(title: "Schedule", image: nil, selectedImage: nil)
        item2.tabBarItem = icon2
        
        let item3 = MapViewController()
        let icon3 = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        item3.tabBarItem = icon3
        
        let item4 = MentorTicketsTableViewController()
        let icon4 = UITabBarItem(title: "Mentorship", image: nil, selectedImage: nil)
        item4.tabBarItem = icon4
        
        let item5 = PrizesViewController()
        let icon5 = UITabBarItem(title: "S & P", image: nil, selectedImage: nil)
        item5.tabBarItem = icon5
        
        let controllers = [item1, item2, item3, item4, item5]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
