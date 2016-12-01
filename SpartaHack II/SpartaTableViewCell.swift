//
//  SpartaTableViewCell.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 12/1/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit


class SpartaTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: SpartaLabel!
    @IBOutlet weak var detailLabel: SpartaLabel!
    @IBOutlet weak var barView: UIView!
    override func layoutSubviews() {
        barView.backgroundColor = Theme.darkGold
    }
}
