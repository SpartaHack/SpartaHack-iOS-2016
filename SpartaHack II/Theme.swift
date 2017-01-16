//
//  Theme.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 9/27/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

struct Theme {
    
    // MARK: Colors
    static let darkBrown = UIColor(red:0.21, green:0.18, blue:0.15, alpha:1.0)
    static let darkGold = UIColor(red:0.71, green:0.54, blue:0.18, alpha:1.0)
    static let mediumGold = UIColor(red:0.83, green:0.69, blue:0.40, alpha:1.0)
    static let lightGold = UIColor(red:0.98, green:0.89, blue:0.64, alpha:1.0)
    static let extraLightGold = UIColor(red:1.00, green:0.95, blue:0.85, alpha:1.0)
    static let white = UIColor(white: 1.0, alpha: 1.0)
    static let lightError = UIColor(red:0.93, green:0.67, blue:0.67, alpha:1.0)
    static let darkError = UIColor(red:0.58, green:0.27, blue:0.27, alpha:1.0)
    
    static var primaryColor = UIColor.black
    static var backgroundColor = UIColor.black
    static var tintColor = UIColor.black
    static var refreshViewBackgroundColor = UIColor.black
    static var refreshTextInactive = UIColor.black
    static var refreshTextActive = UIColor.black
    static var error = UIColor.red
    
    static var gradientStart = UIColor.black
    static var gradientEnd = UIColor.black
    
    static func loadTheme() {
        switch currentTheme() {
        case 0:
            lightTheme()
        case 1:
            darkTheme()
        default:
            lightTheme() // 80s theme maybe?
        }
    }
    
    static func currentTheme() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: "themeKey")
    }
    
    // MARK: Light
    static func lightTheme() {
        primaryColor = darkGold
        tintColor = mediumGold
        backgroundColor = white
        refreshViewBackgroundColor = extraLightGold.withAlphaComponent(0.5)
        refreshTextInactive = mediumGold
        refreshTextActive = lightGold
        
        gradientStart = darkGold
        gradientEnd = mediumGold
        
        error = lightError

        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "themeKey")
    }
    
    // MARK: Dark
    static func darkTheme() {
        primaryColor = lightGold
        tintColor = mediumGold
        backgroundColor = darkBrown
        refreshViewBackgroundColor = mediumGold.withAlphaComponent(0.3)
        refreshTextInactive = mediumGold
        refreshTextActive = lightGold
        
        gradientStart = darkGold
        gradientEnd = mediumGold
        
        error = darkError
        
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: "themeKey")
    }
    
    // Mark: Gradients
    enum Gradient : Int {
        case lightGradient, darkGradient, currentTheme
        
        func getColors() -> Array<CGColor> {
            switch self {
            case .darkGradient:
                return [darkGold.cgColor, extraLightGold.cgColor]
            case .lightGradient:
                return [extraLightGold.withAlphaComponent(0.75).cgColor, white.cgColor]
            case .currentTheme:
                return [gradientStart.cgColor, gradientEnd.cgColor]
                
            }
        }
    }
    
    // ToDo: make sure it removes the old gradient if this is being called a second time!
    static func setHorizontalGradient(on view: UIView, of gradientType: Gradient = .currentTheme) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientType.getColors()
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    static func getDiamondImage() -> UIImage {
        if currentTheme() == 0 {
            return UIImage(named: "diamond")!
        } else {
            return UIImage(named: "diamond-dark")!
        }
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 65
        return sizeThatFits
    }
}
