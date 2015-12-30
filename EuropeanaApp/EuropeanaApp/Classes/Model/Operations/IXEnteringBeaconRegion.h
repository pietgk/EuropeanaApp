//
//  IXEnteringBeaconRegion.h
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 02/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

/* Purpose
    When a beacon is found by the Location Manager ranging mechanism, this operation 
    can be called.
    This in turn starts two other operations
    a) Find a POI uniquely represented by this beacon
    b) Get other POIs around this beacon
    c) Get nearby beacons
 */
#import <Foundation/Foundation.h>
#import "IXBeacon.h"

@protocol BeaconDelegate;

@interface IXEnteringBeaconRegion : NSOperation

@property (nonatomic, readonly, strong, nonnull) IXBeacon *beacon;
@property (nonatomic, assign, nonnull) id<BeaconDelegate> delegate;

- (nonnull instancetype)initWithBeacon:(nonnull IXBeacon *)beacon delegate:(nullable id<BeaconDelegate>) theDelegate;

@end

@protocol BeaconDelegate <NSObject>
- (void)enteringBeaconRegionDidFinish:(nonnull IXEnteringBeaconRegion *)operation;
@end