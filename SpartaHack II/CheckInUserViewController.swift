//
//  CheckInUserViewController.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/6/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class CheckInUserViewController: UIViewController {

    var objectId = String()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dietLabel: UILabel!
    @IBOutlet weak var tshirtSizeLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "User is Already Checked in", preferredStyle: UIAlertControllerStyle.alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptButtonTapped(_ sender: AnyObject) {
    

    }

    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
