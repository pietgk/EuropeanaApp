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

+ (nonnull instancetype) createWithIdentifier:(nonnull NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance;
+ (nonnull instancetype) createWithDictionary:(nonnull NSDictionary *)newDict;
- (nonnull instancetype) initWithDictionary:(nonnull NSDictionary *)newDict;

@end
