//
//  IXPoi.h
//  ArtWhisper
//
//  Created by Axel Roest on 30/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

// contains a Point Of Interest, this could be an artpiece, a building etc.
// A poi contains data about itself, but also which beacons are connected to it with what signal (rssi)

#define kBeaconsKey @"beacons"
#define kPoiKey @"poi"

#import <Foundation/Foundation.h>

@interface IXPoi : NSObject
@property (nonatomic, strong) NSArray *beacons;                 // which beacons are associated with this artpiece?
@property (nonatomic, strong) NSString *name;                   // the name of the place
@property (nonatomic, strong) NSString *caption;                // the initial text spoken
@property (nonatomic, strong) NSString *audio;                  // audio file name
@property (nonatomic, strong) NSArray *infoSources;             // contains further information URLs

+ (instancetype) createWithDictionary:(NSDictionary *)newDict;
- (instancetype) initWithDictionary:(nonnull NSDictionary *)newDict;

@end
