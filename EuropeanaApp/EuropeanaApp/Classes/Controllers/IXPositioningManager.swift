//
//  IXPositioningManager.swift
//  ArtWhisper
//
//  Created by Axel Roest on 19/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

/* For want of a better name.

    Handles corebluetooth manager calls, using nsop queues
*/
import Foundation
import CoreBluetooth
//import IXBeacon


public class IXPositioningManager : NSObject, CBCentralManagerDelegate{
    private let PURGEINTERVAL : NSTimeInterval = 5
    
    private let centralManager : CBCentralManager!
    private let beaconQueue : dispatch_queue_t
    private let data : IXData
    public var serviceUUIDs : Array<String>?
    public var scanning : Bool
    private var purgeTimer : NSTimer?
    
    public override init() {
        beaconQueue = dispatch_queue_create("us.phlux.beaconQueue",  nil)
        centralManager = CBCentralManager(delegate: nil, queue: beaconQueue)
        scanning = false
        data = IXData.sharedData()
        super.init()
        self.centralManager.delegate = self
    }

    public func startScanning() {
//        if let uuids = self.serviceUUIDs {
            // just detect *any* beacon currently
            centralManager.scanForPeripheralsWithServices(nil, options:[CBCentralManagerScanOptionAllowDuplicatesKey:true])
        self.purgeTimer = NSTimer.scheduledTimerWithTimeInterval(PURGEINTERVAL, target: self, selector: "purgeBeaconTimerFired:", userInfo: nil, repeats:true)
//        }
    }
    
    public func stopScanning() {
        centralManager.stopScan()
    }

    public func centralManagerDidUpdateState(central: CBCentralManager) {
        // queue errors and determine BT state
        switch central.state {
        case .Resetting, .PoweredOff, .Unauthorized, .Unsupported:
            stopScanning()
        case .PoweredOn:
            if self.scanning {
                startScanning()
            }
        default:
            stopScanning()
        }
    }
    
    public func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        let beacon = IXBeacon(dictionary: advertisementData)
        beacon.rssi = RSSI.doubleValue
        beacon.lastSeen = NSDate()
        data.addBeacon(beacon)
    }
    
    // or should this method go to IXData?
    private func purgeBeaconTimerFired(timer: NSTimer) {
        // loop through all stored beacons and purge the ones with a lastSeen stamp > PURGEINTERVAL
        // self.data.
    }
}
