//
//  SpartaToast.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 1/9/17.
//  Copyright © 2017 Chris McGrath. All rights reserved.
//

import Foundation
import CRToast

struct SpartaToast {
    static func displayToast(_ message: String) {
        let options:[NSObject:AnyObject]  = [
            kCRToastFontKey as NSObject : UIFont(name: "Lato", size: 18)!,
            kCRToastNotificationPreferredHeightKey as NSObject : NSNumber(value: 93),
            kCRToastTextKey as NSObject : message as AnyObject,
            kCRToastBackgroundColorKey as NSObject : Theme.tintColor,
            kCRToastTextColorKey as NSObject: Theme.backgroundColor,
            kCRToastTextMaxNumberOfLinesKey as NSObject: NSNumber(value: 2),
            kCRToastTimeIntervalKey as NSObject: NSNumber(value: 1.5),
            kCRToastUnderStatusBarKey as NSObject : NSNumber(value: true),
            kCRToastTextAlignmentKey as NSObject : NSNumber(value: NSTextAlignment.center.rawValue),
            //options[kCRToastImageKey] = UIImage(named: "ic_whatever") as AnyObject?
            kCRToastNotificationPresentationTypeKey as NSObject : NSNumber(value: CRToastPresentationType.push.rawValue),
            kCRToastNotificationTypeKey as NSObject : NSNumber(value: CRToastType.custom.rawValue),
            kCRToastAnimationInTypeKey as NSObject : NSNumber(value: CRToastAnimationType.linear.rawValue),
            kCRToastAnimationOutTypeKey as NSObject : NSNumber(value: CRToastAnimationType.linear.rawValue),
            kCRToastAnimationInDirectionKey as NSObject : NSNumber(value: CRToastAnimationDirection.left.rawValue),
            kCRToastAnimationOutDirectionKey as NSObject : NSNumber(value: CRToastAnimationDirection.right.rawValue)
        ]
        
        CRToastManager.showNotification(options: options, completionBlock: { () -> Void in
            print("done!")
        })
    }
}
