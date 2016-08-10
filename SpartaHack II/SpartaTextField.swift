//
//  SpartaTextField.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 2/27/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit
import QuartzCore

class SpartaTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        self.backgroundColor = UIColor.spartaBlack()
        self.textColor = UIColor.whiteColor()
        self.textColor = UIColor.spartaGreen()
        self.layer.borderColor = UIColor.spartaGreen().CGColor
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
