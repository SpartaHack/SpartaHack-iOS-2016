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
        self.tabBar.isTranslucent = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = MapViewController()
        let icon1 = UITabBarItem(title: "Map", image: UIImage(named: "map"), selectedImage: nil)
        item1.tabBarItem = icon1
        
        let item2 = ScheduleViewController()
        let icon2 = UITabBarItem(title: "Schedule", image: UIImage(named: "schedule"), selectedImage: nil)
        item2.tabBarItem = icon2
        
        let item3 = AnnouncementsTableViewController()
        let icon3 = UITabBarItem(title: "Announcements", image: UIImage(named: "announcements"), selectedImage: nil)
        item3.tabBarItem = icon3
        
        let item4 = MentorTicketsTableViewController()
        let icon4 = UITabBarItem(title: "Mentorship", image: UIImage(named: "mentorship"), selectedImage: nil)
        item4.tabBarItem = icon4
        
        let item5 = PrizesViewController()
        let icon5 = UITabBarItem(title: "Prizes! :D", image: UIImage(named: "prizes"), selectedImage: nil)
        item5.tabBarItem = icon5
        
        let controllers = [item1, item2, item3, item4, item5]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        UITabBar.appearance().tintColor = Theme.darkGold
        let borderSize: CGFloat = 1.5
        let tabBarBorder = UIView(frame: CGRect(x: 0,
                                                y: -borderSize,
                                                width: self.tabBar.frame.size.width,
                                                height: borderSize))
        tabBarBorder.backgroundColor = Theme.darkGold
        self.tabBar.addSubview(tabBarBorder)
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
