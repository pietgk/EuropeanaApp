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

- (void) getImageWithBlock:(void (^ _Nonnull)(UIImage * _Nullable))block {
    // get / download image
    self.image = [UIImage imageNamed:@"kawsrijks.png"];
    block(self.image);
}

-(NSString *)description
{
//    return [NSString stringWithFormat:@"<%@: %p> %@ (%@)\n%@",self.class, self, self.name, self.caption, self.beacons];
    return [NSString stringWithFormat:@"<%@: %p> %@ %@",self.class, self, self.name, self.beacons];
}
@end
