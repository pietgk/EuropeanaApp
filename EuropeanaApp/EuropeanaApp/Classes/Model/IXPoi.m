//
//  IXPoi.m
//  ArtWhisper
//
//  Created by Axel Roest on 30/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import "IXPoi.h"
#import "IXBeacon.h"

@implementation IXPoi 


+ (instancetype) createWithDictionary:(nonnull NSDictionary *)newDict
{
    return [[self alloc] initWithDictionary:newDict];
}

#warning untested
-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    IXPoi *newPoi = [[IXPoi alloc] init];
    newPoi.name = [_name copyWithZone:zone];
    newPoi.artist = [_artist copyWithZone:zone];
    newPoi.caption = [_caption copyWithZone:zone];
    newPoi.venue = [_venue copyWithZone:zone];
    newPoi.audio = [_audio copyWithZone:zone];
    newPoi.imageURL = [_imageURL copyWithZone:zone];
    newPoi.websiteURL = [_websiteURL copyWithZone:zone];
    newPoi.audioURL = [_audioURL copyWithZone:zone];
    
    return newPoi;
}

- (instancetype) initWithDictionary:(nonnull NSDictionary *)newDict
{
    self = [super init];
    
    if (self) {
        NSDictionary *poi = newDict[kPoiKey];
        if (poi) {
            [poi enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                @try {
                    [self setValue:obj forKey:key];
                }
                @catch (NSException *exception) {
                }
                @finally {
                }
            }];
        }
        NSArray *beaconJson = newDict[kBeaconsKey];
        if (beaconJson) {
            NSAssert([beaconJson isKindOfClass:NSArray.class],@"beacons json is not an array");
            [self createBeaconsWithJSONArray:beaconJson];
        }
    }
    return self;
}

- (void) createBeaconsWithJSONArray:(NSArray *)newJSON
{
    NSMutableArray *newBeacons = [NSMutableArray arrayWithCapacity:[newJSON count]];
    
    for (NSDictionary *b in newJSON) {
        IXBeacon *newBee = [IXBeacon createWithDictionary:b];
        if (newBee) {
            [newBeacons addObject:newBee];
        } else {
            NSLog(@"Could not add beacon with dict: %@",b);
        }
    }
    self.beacons = [NSArray arrayWithArray:newBeacons];
}

- (BOOL) containsBeacon:(IXBeacon*)aBeacon
{
    for (IXBeacon *beacon in self.beacons) {
        if ([aBeacon isEqualToBeacon:beacon]) {
            return YES;
        }
    }
    return NO;
}

- (void) getImageWithBlock:(void (^ _Nonnull)(UIImage * _Nullable))block {
    // get / download image
    if (self.imageURL) {
        NSURL *url = [NSURL URLWithString:self.imageURL];
        if (![url scheme]) {            // it is a lone filename, not a URL
            NSString *fileName = [self.imageURL stringByDeletingPathExtension];
            NSString *extension = [self.imageURL pathExtension];
            url = [[NSBundle mainBundle] URLForResource:fileName withExtension:extension];
//            url = [NSURL fileURLWithPath:self.imageURL];
        }
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL : url];
            self.image = data ? [UIImage imageWithData: data] : nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                block(self.image);
            });
        });
    } else {
        self.image = [UIImage imageNamed:@"kawsrijks.png"];
        block(self.image);
    }
}

-(NSString *)description
{
//    return [NSString stringWithFormat:@"<%@: %p> %@ (%@)\n%@",self.class, self, self.name, self.caption, self.beacons];
    return [NSString stringWithFormat:@"<%@: %p> %@ %@",self.class, self, self.name, self.beacons];
}

+ (IXPoi  * _Nonnull) mockPoi
{
    IXPoi *newPoi = [[IXPoi alloc] initWithDictionary:@{ @"poi" : @{
                                                       @"name" : @"Skatedoctor" ,
                                                       @"artist" : @"Debra Barraud",
                                                       @"caption" : @"Skatedoctor by Debra Barraud. Every now and then I have a patient asking me: ’Are you sure you know what you’re doing? Don’t you need to wait until the doctor is here? Then I have to explain them that I am the doctor.",
                                                       @"imageURL" : @"http://files.photosnack.net/albums/images/d9ee9ebd3362b1018f6499i323973066/scale-500x500"
                                                       
                                                       }}];
    return newPoi;
}
@end
