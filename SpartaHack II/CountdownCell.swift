//
//  CountdownCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/15/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import UIKit

class CountdownCell: UITableViewCell {
    @IBOutlet weak var daysNumber: SpartaLabel!
    @IBOutlet weak var hoursNumber: SpartaLabel!
    @IBOutlet weak var minutesNumber: SpartaLabel!
    @IBOutlet weak var secondsNumber: SpartaLabel!
    @IBOutlet weak var daysLabel: SpartaLabel!
    @IBOutlet weak var hoursLabel: SpartaLabel!
    @IBOutlet weak var minutesLabel: SpartaLabel!
    @IBOutlet weak var secondsLabel: SpartaLabel!
    
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    var timer: Timer = Timer()
    
    func startCountdown() {
        // Human time (GMT): Sat, 21 Jan 2017 00:00:00 GMT
        let dateComponents = NSDateComponents()
        dateComponents.year = 2017
        dateComponents.month = 1
        dateComponents.day = 21
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        endDate = NSCalendar.current.date(from: dateComponents as DateComponents)! as NSDate
        
        updateCountdown() // Set the countdown
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CountdownCell.updateCountdown), userInfo: nil, repeats: true)
    }
    
    func updateCountdown() {
        startDate = NSDate() // Time now

        let units = Set<Calendar.Component>([.day, .hour, .minute, .second])
        let difference =  NSCalendar.current.dateComponents(units, from: startDate as Date, to: endDate as Date)
        daysNumber.text = "\(difference.day!)"
        hoursNumber.text = "\(difference.hour!)"
        minutesNumber.text = "\(difference.minute!)"
        secondsNumber.text = "\(difference.second!)"
    }
    
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
            self.daysNumber.textColor = Theme.primaryColor
            self.hoursNumber.textColor = Theme.primaryColor
            self.minutesNumber.textColor = Theme.primaryColor
            self.secondsNumber.textColor = Theme.primaryColor
            self.daysLabel.textColor = Theme.primaryColor
            self.hoursLabel.textColor = Theme.primaryColor
            self.minutesLabel.textColor = Theme.primaryColor
            self.secondsLabel.textColor = Theme.primaryColor
        })
    }
    
}
