//
//  UIFont+Extension.swift
//  ArtWhisper
//
//  Created by Axel Roest on 10-12-15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

//Helvetica Neue
//    == HelveticaNeue-Italic
//    == HelveticaNeue-Bold
//    == HelveticaNeue-UltraLight
//    == HelveticaNeue-CondensedBlack
//    == HelveticaNeue-BoldItalic
//    == HelveticaNeue-CondensedBold
//    == HelveticaNeue-Medium
//    == HelveticaNeue-Light
//    == HelveticaNeue-Thin
//    == HelveticaNeue-ThinItalic
//    == HelveticaNeue-LightItalic
//    == HelveticaNeue-UltraLightItalic
//    == HelveticaNeue-MediumItalic
//    == HelveticaNeue

import Foundation

extension UIFont {
    class func awFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.init(name:"HelveticaNeue", size: size)!
    }

    class func awBoldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.init(name:"HelveticaNeue-Bold", size: size)!
    }
    
    class func awItalicFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.init(name:"HelveticaNeue-Italic", size: size)!
    }

    class func iconFontWithSize(size: CGFloat) -> UIFont {
        return UIFont.init(name:"IcoMoon-Free", size: size)!
    }
    
    class func dumpAllFonts() {
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
    }
}
