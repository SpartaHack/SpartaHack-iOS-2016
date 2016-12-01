//
//  SpartaNavigationBar.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 11/30/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import UIKit

/*
 This subclass is needed to modify the height of the NavigationBar.
 All credit goes to this thorough StackOverflow post: http://stackoverflow.com/questions/28705442/ios-8-swift-xcode-6-set-top-nav-bar-bg-color-and-height
 */

class SpartaNavigationBar: UINavigationBar {
    ///The height you want your navigation bar to be of
    static let navigationBarHeight: CGFloat = 70
    
    ///The difference between new height and default height
    static let heightIncrease:CGFloat = navigationBarHeight - 44
    
    private let borderSize: CGFloat = 1.5
    private var bottomBorder: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        let diamondImage = UIImageView(image: UIImage(named: "diamond"))
        diamondImage.frame = CGRect(x: 0, y: 0, width: 50, height: 51)
        self.topItem?.titleView = diamondImage
        
        
        let profileButton = UIButton.init(type: .custom)
        profileButton.setImage(UIImage.init(named: "profile"), for: UIControlState.normal)
        // ToDo: Hook this up to the Profile page
        // button.addTarget(self, action:#selector(ProfileViewController), for: UIControlEvents.touchUpInside)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        let profileButtonItem = UIBarButtonItem.init(customView: profileButton)
        
        self.topItem?.setRightBarButtonItems([profileButtonItem], animated: true)
        
        // Cool border
        self.bottomBorder.backgroundColor = Theme.darkGold
        self.addSubview(self.bottomBorder)
        
        let shift = SpartaNavigationBar.heightIncrease/2
        
        ///Transform all view to shift upward for [shift] point
        self.transform =
            CGAffineTransform(translationX: 0, y: -shift)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shift = SpartaNavigationBar.heightIncrease/2
        
        ///Move the background down for [shift] point
        let classNamesToReposition: [ String ] = [ "_UIBarBackground" ]
        for view: UIView in self.subviews {
            if classNamesToReposition.contains(NSStringFromClass(type(of: view))) {
                let bounds: CGRect = self.bounds
                var frame: CGRect = view.frame
                frame.origin.y = bounds.origin.y + shift - 20.0
                frame.size.height = bounds.size.height + 20.0
                view.frame = frame
            }
        }
        
        self.bottomBorder.frame = CGRect(x: 0,
                                         y: self.frame.size.height + shift,
                                         width: self.frame.size.width,
                                         height: self.borderSize)
        Theme.setHorizontalGradient(of: .darkGradient, on: self.bottomBorder)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let amendedSize:CGSize = super.sizeThatFits(size)
        let newSize:CGSize = CGSize(width: amendedSize.width, height: SpartaNavigationBar.navigationBarHeight);
        return newSize;
    }
}
