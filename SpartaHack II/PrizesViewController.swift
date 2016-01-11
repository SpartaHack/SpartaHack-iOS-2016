//
//  PrizesViewController.swift
//  SpartaHack II
//
//  Created by Chris McGrath on 12/27/15.
//  Copyright © 2015 Chris McGrath. All rights reserved.
//

import UIKit
import CoreData

class PrizeCell: UITableViewCell {
    static let cellIdentifier = "prizeCell"
    @IBOutlet weak var prizeNameLabel: UILabel!
    @IBOutlet weak var prizeDescriptionLabel: UILabel!
    @IBOutlet weak var prizesSponsorLabel: UILabel!
}

class PrizesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParsePrizesDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var prizesArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        ParseModel.sharedInstance.prizeDelegate = self
        ParseModel.sharedInstance.getPrizes()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func didGetPrizes() {
        self.loadData()
    }

    func loadData () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Prize")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            prizesArray = results as! [NSManagedObject]
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Left)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PrizeCell.cellIdentifier) as! PrizeCell
        let prize = prizesArray[indexPath.row]
        cell.prizeNameLabel.text = prize.valueForKey("name") as? String
        cell.prizeDescriptionLabel.text = prize.valueForKey("prizeDescription") as? String
        cell.prizesSponsorLabel.text = "Sponsored by \(prize.valueForKey("sponsor") as! String)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prizesArray.count
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
