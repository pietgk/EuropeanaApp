//
//  UIFont+Extension.swift
//  ArtWhisper
//
//  Created by Axel Roest on 10-12-15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import Foundation

extension UIFont {
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
