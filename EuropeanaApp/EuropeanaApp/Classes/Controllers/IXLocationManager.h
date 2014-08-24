//
//  IXLocationManager.h
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IXLocationManager, IXBeacon, CLBeaconRegion;

@protocol IXLocationManagerDelegate

//TO DISCUSS: I don't think this should be optional (FM)

/**
 *  Inform the delegate a new beacon has been founded.
 *
 *  @param ixLocationManager A singleton instantiation of IXLocationManager.
 *  @param ixBeacon          Custom object to index a spotted beacon.
 *
 *  @discuss This delegate will only inform beacons that doesn't have an RSSI value <= 0
 */
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager spottedIXBeacon:(IXBeacon *) ixBeacon;

/**
 *  Inform the delegate the user has entered a new region that could contains on to several beacons.
 *
 *  @param ixLocationManager A singleton instantiation of IXLocationManager.
 *  @param region            CLRegion object related to the region just entered by the user.
 *
 *  @discuss The system callback for entered region, used under the hood of this callback method, is really reliable with no delay.
 */
- (void) ixLocationManger : (IXLocationManager *)ixLocationManager enteredAssetRegion: (CLRegion *) region;

/**
 *  Inform the delegate the user has entered a new region that could contains on to several beacons.
 *
 *  @param ixLocationManager A singleton instantiation of IXLocationManager.
 *  @param region            CLRegion object related to the region just exited by the user.
 *
 *  *  @discuss The system callback for exited region, used under the hood of this callback method, is NOT reliable with delay of several minutes.
 */
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager exitedAssetRegion: (CLRegion *) region;


@end

@interface IXLocationManager : NSObject

@property (nonatomic, weak) id<IXLocationManagerDelegate> delegate;

// Trigger location manager beacons' ranging
- (void) start;

@end
