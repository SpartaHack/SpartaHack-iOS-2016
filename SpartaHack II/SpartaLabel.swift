//
//  SpartaLabel.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/27/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import QuartzCore

class SpartaLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        self.backgroundColor = UIColor.clear
        self.textColor = UIColor.white
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
    }
}
    
