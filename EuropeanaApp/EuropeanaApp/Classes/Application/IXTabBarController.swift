//
//  IXTabBarController.swift
//  ArtWhisper
//
//  Created by Axel Roest on 06/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation

class IXTabBarController : UITabBarController {
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    // UIViewController should be a IXActiveGuideVCprotocol
    func showActiveGuide() -> UIViewController {
        self.selectedIndex = 3
        
        return self.selectedViewController!
    }
}