//
//  BeaconMonitorOperation.swift
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 04/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

import Foundation
import CoreLocation

public class BeaconMonitorOperation : Operation, CLLocationManagerDelegate {

    private let accuracy: CLLocationAccuracy
    private var manager: CLLocationManager?
    //private let handler: CLLocation -> Void
    private var operationQueue: OperationQueue;
    
    override public init() {
        self.accuracy =  kCLLocationAccuracyHundredMeters;
        self.operationQueue = OperationQueue()
        super.init()
        addCondition(LocationCondition(usage: .WhenInUse))
        addCondition(MutuallyExclusive<BeaconMonitorOperation>())
    }

    override func execute() {
        if !CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion) {
            NSLog("This device doesn't support beacons' monitoring")
            finish()
        } else {
            self.manager = self.locationManager();
            self.executeMonitor()
        }
    }

    private func locationManager() -> CLLocationManager? {
        // `CLLocationManager` needs to be created on a thread with an active run loop
        var manager: CLLocationManager? = nil;
        dispatch_sync(dispatch_get_main_queue()) {
            manager = CLLocationManager()
            manager?.desiredAccuracy = self.accuracy
            manager?.delegate = self
        }
        return manager;
    }
    
    private func executeMonitor() {
        let data = IXData.sharedData()
        for beaconUUID in data.monitoredBeaconUuidSet() { //TODO: support max 20 limit by filtering on gps location filtering
            let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconUUID.UUIDString)
            self.manager?.startMonitoringForRegion(beaconRegion)
        }
        self.manager?.startUpdatingLocation()
    }
    
    override public func cancel() {
        dispatch_async(dispatch_get_main_queue()) {
            self.stopLocationUpdates()
            super.cancel()
        }
    }
    
    private func stopLocationUpdates() {
        manager?.stopUpdatingLocation()
        manager = nil
    }
    
    // MARK: CLLocationManagerDelegate

    public func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        // TODO: self.operationQueue.addOperation(BeaconRangeOperation())
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last where location.horizontalAccuracy <= accuracy else {
            return
        }
        // TODO: update monitored set based on gps location and the gps location of the known beacons
    }
    
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        stopLocationUpdates()
        finishWithError(error)
    }
    
}