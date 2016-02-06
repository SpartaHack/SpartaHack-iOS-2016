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
            print("Results \(results.count)")
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
        
        ParseModel.sharedInstance.mentorDelegate = self
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
