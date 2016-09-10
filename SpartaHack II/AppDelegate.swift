//
//  AppDelegate.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 6/17/15.
//  Copyright (c) 2015 Chris McGrath. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor.spartaBlack()
        UINavigationBar.appearance().tintColor = UIColor.spartaGreen()
        UINavigationBar.appearance().barStyle = .black       

        
        // Set up push notification buttons
        
        // Actions
        let firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "EXTEND"
        firstAction.title = "Extend"
        
        firstAction.activationMode = UIUserNotificationActivationMode.background
        firstAction.isDestructive = false
        firstAction.isAuthenticationRequired = false
        
        let secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "CANCEL"
        secondAction.title = "Cancel ticket"
        
        secondAction.activationMode = UIUserNotificationActivationMode.foreground
        secondAction.isDestructive = false
        secondAction.isAuthenticationRequired = false
        
        
        // category
        
        let firstCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "USER_ACTIONABLE"
        
        let defaultActions = [firstAction, secondAction]
        let minimalActions = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions, for: UIUserNotificationActionContext.default)
        firstCategory.setActions(minimalActions, for: UIUserNotificationActionContext.minimal)
        
        // NSSet of all our categories
        
        let categories = NSSet(objects: firstCategory)
        
        // Enable push notifications
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories:categories as? Set<UIUserNotificationCategory>)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
        

                
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registering for push notifications")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications:  \(error)")
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Required Core Data method
    }

}
