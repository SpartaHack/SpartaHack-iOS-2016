//
//  MentorDetailTicketViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/14/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import Parse

class MentorDetailTicketViewController: UIViewController {

    var userName = ""
    var location = ""
    var subject = ""
    var detail = ""

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userQuery = PFQuery(className: "_User")
        userQuery.getObjectInBackgroundWithId(userName, block: { (object:PFObject?, error:NSError?) -> Void in
            if error == nil {
                if let firstName = object!["firstName"] as? String {
                    if let lastName = object!["lastName"] as? String {
                        let name = "\(firstName) \(lastName)"
                        self.userNameLabel.text = "User's Name: \(name)"
                    }
                } else {
                    self.userNameLabel.text = ""
                }
            }
        })

        
        self.locationLabel.text = "Location: \(location)"
        self.subjectLabel.text = "Subject: \(subject)"
        self.detailTextView.text = detail

        // Do any additional setup after loading the view.
        
        self.locationLabel.textColor = UIColor.spartaGreen()
        self.subjectLabel.textColor = UIColor.spartaGreen()
        self.userNameLabel.textColor = UIColor.spartaGreen()
        self.detailTextView.textColor = UIColor.spartaGreen()
        
        self.locationLabel.backgroundColor = UIColor.spartaBlack()
        self.subjectLabel.backgroundColor = UIColor.spartaBlack()
        self.userNameLabel.backgroundColor = UIColor.spartaBlack()
        self.detailTextView.backgroundColor = UIColor.spartaBlack()
        
        self.detailTextView.layer.borderWidth = 1
        self.detailTextView.layer.cornerRadius = 4
        self.detailTextView.layer.borderColor = UIColor.spartaGreen().CGColor
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
