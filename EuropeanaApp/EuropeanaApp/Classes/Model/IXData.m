//
//  IXData.m
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 28/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import "IXData.h"
#import "IXBeacon.h"
#import "IXPoi.h"

@interface IXData ()
@property (nonatomic, strong) NSArray *beacons;
@property (nonatomic, strong) NSArray *pois;
@end

@implementation IXData
@synthesize beacons=_beacons, pois=_pois;

+ (IXData*)sharedData {
    static IXData *myData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myData = [[self alloc] init];
    });
    return myData;
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray *hoi = self.beacons;
        NSArray *hoipipeloi = self.pois;
        NSLog(@"Beacons: %@",self.beacons);
        NSLog(@"Points of interest: %@",self.pois);
    }
    return self;
}

- (NSArray *) beacons
{
    if (!_beacons) {
        _beacons = [self beaconsFromResourceFile];
    }
    return _beacons;
}

- (NSArray *) pois
{
    if (!_pois) {
        _pois = [self poisFromResourceFile];
    }
    return _pois;
}

-(NSArray*)beaconsFromResourceFile;
{
    // Glimworm beacons.json from http://85.17.193.165:1880/beacons/
    // plus Hermitage 2015: tentoonstelling v.h. Amsterdam Museum: Hollanders van de Gouden Eeuw 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableArray *newBeacons = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *b in jsonArray) {
        IXBeacon *newBee = [IXBeacon createWithDictionary:b];
        if (newBee) {
            [newBeacons addObject:newBee];
        } else {
            NSLog(@"Could not add beacon with dict: %@",b);
        }
    }
    return newBeacons;
}

-(NSArray*)poisFromResourceFile;
{
    // Glimworm beacons.json from http://85.17.193.165:1880/beacons/
    // plus Hermitage 2015: tentoonstelling v.h. Amsterdam Museum: Hollanders van de Gouden Eeuw
    NSString *path = [[NSBundle mainBundle] pathForResource:@"poi" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    NSMutableArray *newPois = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *b in jsonArray) {
        IXPoi *newPee = [IXPoi createWithDictionary:b];
        if (newPee) {
            [newPois addObject:newPee];
        } else {
            NSLog(@"Could not add beacon with dict: %@",b);
        }
    }

    return newPois;
}

-(NSDictionary*)beaconWithUuid:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;
{
    NSDictionary* result = nil;
    // todo uuid
    for (NSDictionary*b in self.beacons) {
        if ([uuid isEqualToString:b[@"uuid"]]
            && [major isEqualToNumber:b[@"major"]]
            && [minor isEqualToNumber:b[@"minor"]] ) {
            result = b;
            break;
        }
    }
    return result;
}

@end
