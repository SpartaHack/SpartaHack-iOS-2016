//
//  MapView.swift
//  SpartaHack 2016
//
//  Created by Chris McGrath on 11/11/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

import UIKit

class MapView: UIView {
    
    @IBOutlet weak var webView: UIWebView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init() {
        self.init()
    }
    
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(nibName: nibNamed, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
