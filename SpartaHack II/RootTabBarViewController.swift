//
//  RootTabBarViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 1/7/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import Parse
import CoreData

let headerFontSize:CGFloat = 20;

class RootTabBarViewController: UITabBarController, ParseMentorDelegate {

    var subjects = [NSManagedObject]()
    @IBOutlet weak var mentorButton: UIBarButtonItem!
    
    func fetch (){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Mentor")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            subjects = results as! [NSManagedObject]
            if results.count < 1 {
                mentorButton.enabled = false
                mentorButton.tintColor = UIColor.spartaBlack()
            } else {
                mentorButton.enabled = true
                mentorButton.tintColor = UIColor.spartaGreen()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.spartaGreen()
        self.tabBar.backgroundColor = UIColor.spartaBlack()
        self.tabBar.barTintColor = UIColor.spartaBlack()
        
        mentorButton.enabled = false
        mentorButton.tintColor = UIColor.spartaBlack()
        
        ParseModel.sharedInstance.mentorDelegate = self
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Moondance", size: 20)!, NSForegroundColorAttributeName: UIColor.spartaGreen()], forState: .Normal)
        
        
        let label = UILabel(frame: CGRectMake(0,0,440,44))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Moondance", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.text = "< SPARTAHACK />"
        self.navigationController?.navigationBar.topItem?.titleView = label
//        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Moondance", size: 20)!]
//        self.navigationController?.navigationBar.topItem?.
//        self.navigationController?.navigationBar.topItem?.title = "< SPARTAHACK />"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.currentUser() == nil {
            // hide the mentor button
            mentorButton.enabled = false
            mentorButton.tintColor = UIColor.spartaBlack()
        } else {
            ParseModel.sharedInstance.getMentorCategories()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func didGetMentorCategories() {
        self.fetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileButtonTapped(sender: AnyObject) {
        if PFUser.currentUser() == nil {
            // load the login view
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
        } else {
            // load the profile
            self.navigationController?.performSegueWithIdentifier("profileSegue", sender: nil)
        }
    }

    
    @IBAction func mentorshipButtonTapped(sender: AnyObject) {
        if PFUser.currentUser() == nil {
            // load the login view
            self.navigationController?.performSegueWithIdentifier("loginSegue", sender: nil)
        } else {
            // load the profile
            self.navigationController?.performSegueWithIdentifier("mentorTickets", sender: nil)
        }
    }
}
