//
//  UIColor+Extension.swift
//  ArtWhisper
//
//  Created by Axel Roest on 23/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import Foundation

extension UIColor {
    class func colorFromHex(hexcolor: UInt, alpha:CGFloat) -> UIColor {
        return UIColor(red: (CGFloat((hexcolor & 0xFF0000) >> 16) / 255.0),
            green: CGFloat((hexcolor & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((hexcolor & 0x0000FF)) / 255.0, alpha: alpha)
    }
    
    class func colorFromHex(hexcolor:UInt) -> UIColor {
        return UIColor.colorFromHex(hexcolor, alpha: 1.0)
    }

    // MARK : app specific colours
    class func darkGrayBackground() -> UIColor {
        return UIColor.colorFromHex(0xf2f2f2)
    }
    
    class func whiteBackground() -> UIColor {
        return UIColor.colorFromHex(0xffffff)
    }

    class func navigationBackground() -> UIColor {
        return UIColor.colorFromHex(0x2e3192)
    }
}