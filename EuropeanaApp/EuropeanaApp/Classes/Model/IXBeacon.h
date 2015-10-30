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
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, strong) NSNumber *minor;
@property (nonatomic, strong) NSNumber *signal;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSString *beaconType;
@property (nonatomic, strong) NSMutableArray *extraInfo;

+ (instancetype) createWithIdentifier:(NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance;
+ (instancetype) createWithDictionary:(NSDictionary *)newDict;
- (instancetype) initWithDictionary:(nonnull NSDictionary *)newDict;

@end
