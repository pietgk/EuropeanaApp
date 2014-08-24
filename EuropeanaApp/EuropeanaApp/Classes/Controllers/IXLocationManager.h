//
//  IXLocationManager.h
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXBeacon.h"

@class IXLocationManager;

@protocol IXLocationManagerDelegate <NSObject>

@optional
/*
 *
 */
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager spottedIXBeacon:(IXBeacon *) ixBeacon;

/*
 *
 */
- (void) ixLocationManger : (IXLocationManager *)ixLocationManager exitAssetRegion:(IXBeacon *) ixBeacon;

/*
 *
 */
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager enteredIXBeaconRegion: (IXBeacon *) ixBeacon;


@end

@interface IXLocationManager : NSObject

- (instancetype) initWithDelegate:(id <IXLocationManagerDelegate>)aDelegate;
- (void) start;
@end
