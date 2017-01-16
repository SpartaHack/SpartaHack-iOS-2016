//
//  CountdownCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/15/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import UIKit

class CountdownCell: UITableViewCell {
    @IBOutlet weak var hoursNumber: SpartaLabel!
    @IBOutlet weak var minutesNumber: SpartaLabel!
    @IBOutlet weak var secondsNumber: SpartaLabel!
    @IBOutlet weak var hoursLabel: SpartaLabel!
    @IBOutlet weak var minutesLabel: SpartaLabel!
    @IBOutlet weak var secondsLabel: SpartaLabel!
    
    var countdownStartDate: NSDate = NSDate()
    var countdownEndDate: NSDate = NSDate()
    var hackathonEndDate: NSDate = NSDate()
    var timer: Timer = Timer()
    
    func startCountdown() {
        // Human time (GMT): Sat, 21 Jan 2017 00:00:00 GMT
        let hackathonStartDateComponents = NSDateComponents()
        hackathonStartDateComponents.year = 2017
        hackathonStartDateComponents.month = 1
        hackathonStartDateComponents.day = 21
        hackathonStartDateComponents.hour = 0
        hackathonStartDateComponents.minute = 0
        hackathonStartDateComponents.second = 0
        // Default end date to hackathon start date
        countdownEndDate = NSCalendar.current.date(from: hackathonStartDateComponents as DateComponents)! as NSDate
        
        // Human time (GMT): Sat, 22 Jan 2017 12:00:00 GMT
        let hackathonEndDateComponents = NSDateComponents()
        hackathonEndDateComponents.year = 2017
        hackathonEndDateComponents.month = 1
        hackathonEndDateComponents.day = 22
        hackathonEndDateComponents.hour = 12
        hackathonEndDateComponents.minute = 0
        hackathonEndDateComponents.second = 0
        hackathonEndDate = NSCalendar.current.date(from: hackathonEndDateComponents as DateComponents)! as NSDate
        
        updateCountdown() // Set the countdown
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CountdownCell.updateCountdown), userInfo: nil, repeats: true)
    }
    
    func updateCountdown() {
        countdownStartDate = NSDate() // Time now

        let units = Set<Calendar.Component>([.hour, .minute, .second])
        let difference =  NSCalendar.current.dateComponents(units, from: countdownStartDate as Date, to: countdownEndDate as Date)
        
        if difference.second! >= 0 {
            hoursNumber.text = "\(difference.hour!)"
            minutesNumber.text = "\(difference.minute!)"
            secondsNumber.text = "\(difference.second!)"
        } else {
            // Countdown ended!
            countdownEndDate = hackathonEndDate
        }
    }
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
            self.hoursNumber.textColor = Theme.primaryColor
            self.minutesNumber.textColor = Theme.primaryColor
            self.secondsNumber.textColor = Theme.primaryColor
            self.hoursLabel.textColor = Theme.primaryColor
            self.minutesLabel.textColor = Theme.primaryColor
            self.secondsLabel.textColor = Theme.primaryColor
        })
    }
    
}
