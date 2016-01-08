//
//  FindPOIofBeaconOperation.swift
//  ArtWhisper
//
//  Created by Axel Roest on 04/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//
/* 
    Find the POIs that might belong to this beacon
    if a POI is uniquely attached to this beacon (i.e. only one beacon for this POI, then start
    rangedSingleBeacon operation, which shows and speaks out the POI
*/

import Foundation

class FindPOIofBeaconOperation : Operation {
    // MARK: Properties
    let beacon : IXBeacon
    
    // MARK: Initialization
    init(newBeacon:IXBeacon) {
        beacon = newBeacon
        
        super.init()
    }
    
    override func execute() {
        let dataManager = IXData.sharedData()
        let pois = dataManager.poisOfBeacon(self.beacon)
        if (pois.count == 1) {          // we can only do this dirty trick when a beacon is uniquely connected to ONE poi
            // Add the poi to the handlePOI OperationQueue
            let delegate = UIApplication.sharedApplication().delegate as! IXAppDelegate
            delegate.showActiveGuideWithPoi(pois[0])
        }
    }

}