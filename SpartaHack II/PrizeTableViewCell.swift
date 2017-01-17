//
//  PrizeTableViewCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/16/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import UIKit

class PrizeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: SpartaLabel!
    @IBOutlet weak var detailLabel: SpartaLabel!
    @IBOutlet weak var sponsorLabel: SpartaLabel!
    @IBOutlet weak var barView: UIView!
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
            self.barView.backgroundColor = Theme.primaryColor
            self.titleLabel.textColor = Theme.primaryColor
            self.detailLabel.textColor = Theme.primaryColor
            self.sponsorLabel.textColor = Theme.primaryColor
        })
    }
    
}
