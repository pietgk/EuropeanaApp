//
//  IXPoi.h
//  ArtWhisper
//
//  Created by Axel Roest on 30/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

// contains a Point Of Interest, this could be an artpiece, a building etc.
// A poi contains data about itself, but also which beacons are connected to it with what signal (rssi)

#import <UIKit/UIKit.h>

#define kBeaconsKey @"beacons"
#define kPoiKey @"poi"

@interface IXPoi : NSObject <NSCopying>
// currently beacons contains actual IXBeacons, but in the end it should be references to the known beacons object
@property (nonatomic, strong, nonnull) NSArray   *beacons;                 // which beacons are associated with this artpiece?
@property (nonatomic, strong, nullable) NSString *name;                   // the name of the place
@property (nonatomic, strong, nullable) NSString *artist;                   // the name of the artist
@property (nonatomic, strong, nullable) NSString *caption;                // the initial text spoken
@property (nonatomic, strong, nullable) NSString *venue;                // the venue of the exhibition
@property (nonatomic, strong, nullable) NSString *audio;                  // audio file name
@property (nonatomic, strong, nullable) NSArray  *infoSources;             // contains further information URLs
@property (nonatomic, strong, nullable) NSString *imageURL;             //
@property (nonatomic, strong, nullable) UIImage  *image;             //
@property (nonatomic, strong, nullable) NSString *websiteURL;             // to link through
@property (nonatomic, strong, nullable) NSString *audioURL;             // url of audio file

+ (nonnull instancetype) createWithDictionary:(nonnull NSDictionary *)newDict;
- (nonnull instancetype) initWithDictionary:(nonnull NSDictionary *)newDict;

- (void) getImageWithBlock:(void (^ _Nonnull)(UIImage * _Nullable))block;

+ (IXPoi  * _Nonnull ) mockPoi;

// Returns true if this poi contains the beacon
- (BOOL) containsBeacon:(nonnull IXBeacon*)aBeacon;

// Returns true if only one beacon is needed to activate this poi
- (BOOL) isSingularBeacon;

@end
