//
//  IXHistoricPoi.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation

@objc class IXHistoricPoi : NSObject {
    var visitDate: NSDate?
    var visitDuration: NSTimeInterval?
    var poi: IXPoi?
    
    init(poi: IXPoi, date:NSDate, duration:NSTimeInterval) {
        self.poi = poi
        self.visitDate = date
        self.visitDuration = duration
        
        super.init()
    }
}