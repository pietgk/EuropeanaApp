//
//  IXBeacon.h
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//
// TODO: need to refactor this into child of KCSIBeaconInfo

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface IXBeacon : NSObject
@property (nonatomic, copy, nonnull) NSString *uuid;
@property (nonatomic, strong, nonnull) NSNumber *major;
@property (nonatomic, strong, nonnull) NSNumber *minor;
@property (nonatomic, strong, nullable) NSNumber *signal;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, copy, nonnull) NSString *identifier;
@property (nonatomic, copy, nonnull) NSString *remarks;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy, nullable) NSString *beaconType;
@property (nonatomic, strong, nullable) NSMutableArray *extraInfo;
@property (nonatomic, assign) double rssi;
@property (nonatomic, strong, nullable) NSDate *lastSeen;
@property (nonatomic, assign) CLProximity proximity;
@property (nonatomic, assign) CGPoint position;             // necessary for CBBeaconsMap, maybe we can get rid of it later?


+ (nonnull instancetype) createWithIdentifier:(nonnull NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance;
+ (nonnull instancetype) createWithDictionary:(nonnull NSDictionary *)newDict;
- (nonnull instancetype) initWithDictionary:(nonnull NSDictionary *)newDict;

+ (nonnull NSString*)beaconKeyForUuid:(nonnull NSString*)uuid major:(int)major minor:(int)minor;
- (nonnull NSString*)key;
- (nonnull NSUUID*) UUID;

-(BOOL) isEqualToBeacon:(nonnull IXBeacon *)anotherBeacon;

@end


@interface IXBeacon (Debugging)
@property CGPoint position; // pixels
@property (nonatomic, strong, nullable) NSString* name;         // FIXME: could be method with major+minor

@end
