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
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
//            self.daysNumber.textColor = Theme.primaryColor
//            self.hoursNumber.textColor = Theme.primaryColor
//            self.minutesNumber.textColor = Theme.primaryColor
//            self.secondsNumber.textColor = Theme.primaryColor
//            self.daysLabel.textColor = Theme.primaryColor
//            self.hoursLabel.textColor = Theme.primaryColor
//            self.minutesLabel.textColor = Theme.primaryColor
//            self.secondsLabel.textColor = Theme.primaryColor
        })
    }
    
}
