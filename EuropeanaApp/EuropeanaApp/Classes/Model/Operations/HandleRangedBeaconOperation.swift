//
//  HandleRangedBeaconOperation.swift
//  ArtWhisper
//
//  Created by Axel Roest on 04/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

/* Purpose
    When a beacon is found by the Location Manager ranging mechanism, this operation
    can be called.
    This in turn starts three other operations
    a) Find a POI uniquely represented by this beacon
    b) Get other POIs around this beacon
    c) Get nearby beacons
*/

import Foundation

class HandleRangedBeaconOperation : Operation {
// MARK: Properties
    let operationQueue = OperationQueue()
    
// MARK: Initialization
    init(beacon:IXBeacon) {
        
        let findPOIOperation = FindPOIofBeaconOperation.init(newBeacon: beacon)
        // TODO: Should we add an observer to this operation to handle the outcome?
        
        operationQueue.addOperation(findPOIOperation)
        
        super.init()
        // tell IXData to initiate GetPOIsOfBeaconOperation(beacon)
    }
    
}