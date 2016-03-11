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

#define kRangedBeaconAddedNotification  @"kRangedBeaconAddedNotification"

@class IXHistoricPoi;

@interface IXData : NSObject

//@property (nonatomic, strong) NSArray<IXBeacon *> *beacons;
@property (nonatomic, readonly, nullable) NSMutableDictionary <NSString*,IXBeacon *> *beacons; // key is uuid_major_minor

@property (nonatomic, readonly, nullable) NSMutableArray<IXPoi *> *pois;
@property (nonatomic, readonly, nullable) NSMutableArray<IXHistoricPoi *> *historicPois;
@property (nonatomic, readonly, nullable) NSArray<IXPoi *> *suggestions;
@property (nonatomic, readonly, nullable) NSArray<CLBeaconRegion *> *localRegions;

- (void) setBeaconArray:(NSArray <IXBeacon *>* _Nonnull) newBeacons;

+ (nonnull IXData*)sharedData;

- (nonnull NSSet<NSUUID*> *)monitoredBeaconUuidSet;

- (nullable IXBeacon*)beaconWithUuid:(nonnull NSString*)uuid major:(nonnull NSNumber*)major minor:(nonnull NSNumber*)minor;

/* adds a found (ranged) beacon to the rangedBeacons array */
- (void) addRangedBeacon:( IXBeacon * _Nonnull )newBeacon;

- (nullable IXPoi*)poiClosestToBeacons:(nonnull NSArray<IXBeacon*> *)currentBeacons;
- (nonnull NSArray <IXPoi*>  *) poisOfBeacon:(nonnull IXBeacon *)aBeacon;

- (IXPoi  * _Nonnull) mockPoi;
- (IXPoi  * _Nonnull) previousMockPoi;

- (void) addPoi:(IXPoi * _Nonnull)newPoi;

- (void) addHistoricPoi:(IXHistoricPoi * _Nonnull) hPoi;
- (BOOL) poiIsHistoricPoi:(IXPoi * _Nonnull) poi;
- (void) clearHistoricPois;

@end
