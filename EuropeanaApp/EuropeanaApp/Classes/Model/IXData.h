//
//  IXData.h
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 28/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXBeacon.h"
#import "IXPoi.h"

@interface IXData : NSObject

+ (nonnull IXData*)sharedData;

- (nonnull NSSet<NSUUID*> *)monitoredBeaconUuidSet;

- (nullable IXBeacon*)beaconWithUuid:(nonnull NSString*)uuid major:(nonnull NSNumber*)major minor:(nonnull NSNumber*)minor;
- (nullable IXPoi*)poiClosestToBeacons:(nonnull NSArray<IXBeacon*> *)currentBeacons;

@end
