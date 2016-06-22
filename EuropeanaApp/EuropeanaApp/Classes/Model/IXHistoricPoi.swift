//
//  IXHistoricPoi.swift
//  ArtWhisper
//
//  Created by Axel Roest on 07/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation

@objc class IXHistoricPoi : NSObject , NSCoding {
    var visitDate: NSDate?
    var visitDuration: NSTimeInterval?
    var poi: IXPoi?
    
    init(poi: IXPoi, date:NSDate, duration:NSTimeInterval) {
        self.poi = poi
        self.visitDate = date
        self.visitDuration = duration
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let visitDate = aDecoder.decodeObjectForKey("AWHistoricVisitDate") as! NSDate
//        let visitDuration = NSTimeInterval(aDecoder.decodeDoubleForKey("AWHistoricVisitDuration"))
        let visitDuration = aDecoder.decodeDoubleForKey("AWHistoricVisitDuration")
        let poi = aDecoder.decodeObjectForKey("AWHistoricPoi") as! IXPoi
        self.init(poi:poi, date:visitDate, duration:visitDuration)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(visitDate, forKey: "AWHistoricVisitDate")
        let dur = visitDuration ?? 0.0
        aCoder.encodeDouble(dur, forKey: "AWHistoricVisitDuration")
        aCoder.encodeObject(poi, forKey: "AWHistoricPoi")
    }
    
}