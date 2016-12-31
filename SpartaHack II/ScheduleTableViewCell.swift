//
//  ScheduleTableViewCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/30/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: SpartaLabel!
    @IBOutlet weak var detailLabel: SpartaLabel!
    @IBOutlet weak var timeLabel: SpartaLabel!
    @IBOutlet weak var locationLabel: SpartaLabel!
    @IBOutlet weak var barView: UIView!
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
            self.barView.backgroundColor = Theme.primaryColor
            self.titleLabel.textColor = Theme.primaryColor
            self.detailLabel.textColor = Theme.primaryColor
            self.timeLabel.textColor = Theme.tintColor
            self.locationLabel.textColor = Theme.tintColor
        })
    }
}
