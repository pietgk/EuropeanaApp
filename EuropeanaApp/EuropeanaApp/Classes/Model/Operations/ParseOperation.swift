//
//  ParseOperation.swift
//  ArtWhisper
//
//  Created by Axel Roest on 30/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation

class ParseOperation : Operation {
    let cacheFile: NSURL
    
    /**
     - parameter cacheFile: The file `NSURL` from which to load earthquake data.
     */
    init(cacheFile: NSURL) {
        
        /*
        Use the overwrite merge policy, because we want any updated objects
        to replace the ones in the store.
        */
        
        self.cacheFile = cacheFile
        
        super.init()
        
        name = "Parse Data " + cacheFile.path!
    }
    
    override func execute() {
        guard let stream = NSInputStream(URL: cacheFile) else {
            finish()
            return
        }
        
        stream.open()
        
        defer {
            stream.close()
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: []) as? [String: AnyObject]
            
            // depending on the payload, call various routines, could be later moved to generic functions
            if let pois = json?["pois"] as? [[String: AnyObject]] {
                parsePois(pois)
            } else if let beacons = json?["beacons"] as? [[String: AnyObject]] {
                parseBeacons(beacons)
            } else {
                finish()
            }
        }
        catch let jsonError as NSError {
            finishWithError(jsonError)
        }
    }
    
    private func parsePois(pois: [[String: AnyObject]]) {
        let pois = pois.flatMap { IXPoi(dictionary: $0) }
        
        for newPoi in pois {
            IXData .sharedData().addPoi(newPoi)
        }
        
        self.finishWithError(nil)
    }

    private func parseBeacons(beacons: [[String: AnyObject]]) {
        let beacons = beacons.flatMap { IXPoi(dictionary: $0) }
        
        for newBeacon in beacons {
            // IXData .sharedData().addBeacon(newBeacon)
        }
        
        self.finishWithError(nil)
    }

    private func insert<T>(parsed: T) {
        // detect what is T, create new instances of it
    }
    
}
