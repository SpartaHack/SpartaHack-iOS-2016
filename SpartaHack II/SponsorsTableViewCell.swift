//
//  SponsorsTableViewCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/5/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import Foundation

class SponsorsTableViewCell: UITableViewCell {
    @IBOutlet weak var sponsorImageView: UIImageView!
    
    override func layoutSubviews() {
        UIView.animate(withDuration: 1.0, animations: {
            self.backgroundColor = .clear
            self.contentView.backgroundColor = Theme.backgroundColor
        })
    }
}
