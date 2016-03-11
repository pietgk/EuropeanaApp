//
//  GetLocalBeaconsOperation.swift
//  ArtWhisper
//
//  Created by Axel Roest on 30/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation

class GetLocalBeaconsOperation : GroupOperation {
    let location : CLLocationCoordinate2D
    let downloadOperation: DownloadOperation
    let parseOperation: ParseOperation
    private var hasProducedAlert = false

    init(newLocation:CLLocationCoordinate2D, completionHandler: Void -> Void) {
        location = newLocation
        let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        let cacheFile = cachesFolder.URLByAppendingPathComponent("earthquakes.json")
        
        let beaconURL = NSURL(string: "http://localhost/")!
        downloadOperation = DownloadOperation(url: beaconURL, cacheFile: cacheFile)
        parseOperation = ParseOperation(cacheFile: cacheFile)

        let finishOperation = NSBlockOperation(block: completionHandler)

        // These operations must be executed in order
        parseOperation.addDependency(downloadOperation)
        finishOperation.addDependency(parseOperation)
        
        super.init(operations: [downloadOperation, parseOperation, finishOperation])
        
        name = "Get Data for location"
    }
    
    override func operationDidFinish(operation: NSOperation, withErrors errors: [NSError]) {
        if let firstError = errors.first where (operation === downloadOperation || operation === parseOperation) {
            produceAlert(firstError)
        }
    }
    
    private func produceAlert(error: NSError) {
        /*
        We only want to show the first error, since subsequent errors might
        be caused by the first.
        */
        if hasProducedAlert { return }
        
        let alert = AlertOperation()
        
        let errorReason = (error.domain, error.code, error.userInfo[OperationConditionKey] as? String)
        
        // These are examples of errors for which we might choose to display an error to the user
        let failedReachability = (OperationErrorDomain, OperationErrorCode.ConditionFailed, ReachabilityCondition.name)
        
        let failedJSON = (NSCocoaErrorDomain, NSPropertyListReadCorruptError, nil as String?)
        
//        switch errorReason {
//        case failedReachability:
//            // We failed because the network isn't reachable.
//            let hostURL = error.userInfo[ReachabilityCondition.hostKey] as! NSURL
//            
//            alert.title = "Unable to Connect"
//            alert.message = "Cannot connect to \(hostURL.host!). Make sure your device is connected to the internet and try again."
//            
//        case failedJSON:
//            // We failed because the JSON was malformed.
//            alert.title = "Unable to Download"
//            alert.message = "Cannot download earthquake data. Try again later."
//            
//        default:
//            return
//        }
        
        produceOperation(alert)
        hasProducedAlert = true
    }

}