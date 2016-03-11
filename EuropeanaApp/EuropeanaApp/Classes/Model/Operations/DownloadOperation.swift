//
//  DownloadOperation.swift
//  ArtWhisper
//
//  Created by Axel Roest on 30/01/16.
//  Copyright © 2016 Phluxus. All rights reserved.
//

import Foundation

class DownloadOperation : GroupOperation {
    // MARK: Properties
    
    let cacheFile: NSURL
    
    // MARK: Initialization
    init(url: NSURL, cacheFile: NSURL) {
        self.cacheFile = cacheFile
        
        /*
        Since this server is out of our control and does not offer a secure
        communication channel, we'll use the http version of the URL and have
        added "earthquake.usgs.gov" to the "NSExceptionDomains" value in the
        app's Info.plist file. When you communicate with your own servers,
        or when the services you use offer secure communication options, you
        should always prefer to use https.
        */
        
        super.init(operations: [])
        name = "Download " + url.path!

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
            do {
                /*
                If we already have a file at this location, just delete it.
                Also, swallow the error, because we don't really care about it.
                */
                try NSFileManager.defaultManager().removeItemAtURL(cacheFile)
            }
            catch { }
            
            do {
                try NSFileManager.defaultManager().moveItemAtURL(localURL, toURL: cacheFile)
            }
            catch let error as NSError {
                aggregateError(error)
            }
            
        }
        else if let error = error {
            aggregateError(error)
        }
        else {
            // Do nothing, and the operation will automatically finish.
        }
    }

}