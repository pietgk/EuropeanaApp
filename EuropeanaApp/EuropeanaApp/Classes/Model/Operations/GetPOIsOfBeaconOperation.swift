//
//  GetPOIsOfBeaconOperation.swift
//  ArtWhisper
//
//  Created by Axel Roest on 04/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

/* Get POIs to which this beacon belongs
*/

import Foundation

class GetPOIsOfBeaconOperation : GroupOperation {

    // MARK: Properties
    
    // MARK: Initialization
    init(beacon:IXBeacon) {
        super.init(operations: [])
        // should be our URL or
        let url = NSURL(string: "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_month.geojson")!
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) { url, response, error in
            self.downloadFinished(url, response: response as? NSHTTPURLResponse, error: error)
        }
        
        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: url)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        addOperation(taskOperation)
    }

    func downloadFinished(url: NSURL?, response: NSHTTPURLResponse?, error: NSError?) {
        if let localURL = url {
//            do {
//                /*
//                If we already have a file at this location, just delete it.
//                Also, swallow the error, because we don't really care about it.
//                */
//                try NSFileManager.defaultManager().removeItemAtURL(cacheFile)
//            }
//            catch { }
            
//            do {
//                try NSFileManager.defaultManager().moveItemAtURL(localURL, toURL: cacheFile)
//            }
//            catch let error as NSError {
//                aggregateError(error)
//            }
            
        }
        else if let error = error {
            aggregateError(error)
        }
        else {
            // Do nothing, and the operation will automatically finish.
        }
    }

}