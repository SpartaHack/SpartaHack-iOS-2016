//
//  CreateTicketViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 1/10/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class CreateTicketViewController: UIViewController, ParseTicketDelegate {
    var topic = ""
    var topicObjId = ""
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ParseModel.sharedInstance.ticketDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topicLabel.text = topic
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSubmitTicket(success: Bool) {
        if success {
            self.dismissViewControllerAnimated(true, completion:nil)
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func submitButtonTapped(sender: AnyObject) {
        ParseModel.sharedInstance.submitUserTicket(topicObjId, subject: subjectTextField.text!, description: descriptionTextField.text!)
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
