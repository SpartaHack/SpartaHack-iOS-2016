//
//  SpartaTabBarViewController.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 10/6/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

class SpartaTabBarViewController: UITabBarController, UITabBarControllerDelegate, SpartaNavigationBarDelegate {
    private var lastKnownTheme = Theme.currentTheme()
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.tabBar.isTranslucent = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = MapViewController()
        let icon1 = UITabBarItem(title: "Map", image: UIImage(named: "map"), selectedImage: UIImage(named: "map-selected"))
        icon1.image = icon1.image?.withRenderingMode(.alwaysOriginal)
        icon1.selectedImage = icon1.selectedImage?.withRenderingMode(.alwaysOriginal)
        
        item1.tabBarItem = icon1
        
        let item2 = ScheduleViewController()
        let icon2 = UITabBarItem(title: "Schedule", image: UIImage(named: "schedule"), selectedImage: UIImage(named: "schedule-selected"))
        icon2.image = icon2.image?.withRenderingMode(.alwaysOriginal)
        icon2.selectedImage = icon2.selectedImage?.withRenderingMode(.alwaysOriginal)

        item2.tabBarItem = icon2
        
        let item3 = AnnouncementsTableViewController()
        let icon3 = UITabBarItem(title: "Announcements", image: UIImage(named: "announcements"), selectedImage: UIImage(named: "announcements-selected"))
        icon3.image = icon3.image?.withRenderingMode(.alwaysOriginal)
        icon3.selectedImage = icon3.selectedImage?.withRenderingMode(.alwaysOriginal)
        
        item3.tabBarItem = icon3
        
        let item4 = MentorshipViewController()
        let icon4 = UITabBarItem(title: "Mentorship", image: UIImage(named: "mentorship"), selectedImage: UIImage(named: "mentorship-selected"))
        icon4.image = icon4.image?.withRenderingMode(.alwaysOriginal)
        icon4.selectedImage = icon4.selectedImage?.withRenderingMode(.alwaysOriginal)
        
        item4.tabBarItem = icon4
        
        let item5 = PrizesViewController()
        let icon5 = UITabBarItem(title: "Prizes! :D", image: UIImage(named: "prizes"), selectedImage: UIImage(named: "prizes-selected"))
        icon5.image = icon5.image?.withRenderingMode(.alwaysOriginal)
        icon5.selectedImage = icon5.selectedImage?.withRenderingMode(.alwaysOriginal)
        
        item5.tabBarItem = icon5
        
        let controllers = [item1, item2, item3, item4, item5]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        
        // Move just the text up a few pixels
        for item in controllers {
            item.tabBarItem.imageInsets.bottom = 3
            item.tabBarItem.imageInsets.top = -3
            item.tabBarItem.titlePositionAdjustment.vertical = -5
        }
        
        self.tabBar.barTintColor = Theme.backgroundColor
        self.tabBar.tintColor = Theme.darkGold
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Theme.tintColor], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Theme.tintColor], for: .normal)
        
        let borderSize: CGFloat = 1.5
        let tabBarBorder = UIView(frame: CGRect(x: 0,
                                                y: -borderSize,
                                                width: self.tabBar.frame.size.width,
                                                height: borderSize))
        Theme.setHorizontalGradient(on: tabBarBorder)
        self.tabBar.addSubview(tabBarBorder)
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let spartaTableViewController = viewController as? SpartaTableViewController {
            if spartaTableViewController.needsThemeUpdate() {
                spartaTableViewController.updateTheme()
            }
        }
        return true
    }
    
    func onThemeChange() {
        self.tabBar.barTintColor = Theme.backgroundColor
        self.tabBar.tintColor = Theme.darkGold
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Theme.tintColor], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Theme.tintColor], for: .normal)
    }
}
