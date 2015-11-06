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
//@property (nonatomic, strong) NSArray<IXBeacon *> *beacons;
@property (nonatomic, strong) NSDictionary<NSString*,IXBeacon *> *beacons; // key is uuid_major_minor

@property (nonatomic, strong) NSMutableSet<NSUUID*> *monitoredBeaconUuidSet;

@property (nonatomic, strong) NSDictionary<NSString*,CLBeaconRegion *> *beaconsRanged; // key is uuid_major_minor

@property (nonatomic, strong) NSArray<IXPoi *> *pois;

@end

@implementation IXData
//@synthesize beacons=_beacons, pois=_pois;

+ (IXData*)sharedData;
{
    static IXData *myData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myData = [[self alloc] init];
    });
    return myData;
}

- (instancetype)init {
    if (self = [super init]) {
        //NSArray *hoi = self.beacons;
        //NSArray *hoipipeloi = self.pois;
        //NSLog(@"Beacons: %@",self.beacons);
        //NSLog(@"Points of interest: %@",self.pois);
    }
    return self;
}

- (NSDictionary<NSString*,IXBeacon *>*) beacons;
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

-(NSDictionary<NSString*,IXBeacon *>*)beaconsFromResourceFile;
{
    // Glimworm beacons.json from http://85.17.193.165:1880/beacons/
    // plus Hermitage 2015: tentoonstelling v.h. Amsterdam Museum: Hollanders van de Gouden Eeuw 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableDictionary<NSString*,IXBeacon *>* newBeacons = [NSMutableDictionary dictionaryWithCapacity:[jsonArray count]];
    for (NSDictionary *b in jsonArray) {
        IXBeacon *newBee = [IXBeacon createWithDictionary:b];
        if (newBee) {
            [newBeacons addEntriesFromDictionary: @{newBee.key:newBee} ];
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

- (NSSet<NSUUID*> *)monitoredBeaconUuidSet;
{
    if (!_monitoredBeaconUuidSet) {
        _monitoredBeaconUuidSet = [NSMutableSet set];
        for (NSString* key in self.beacons) {
            IXBeacon* beacon = self.beacons[key];
            [_monitoredBeaconUuidSet addObject:beacon.UUID];
        }
    }
    return _monitoredBeaconUuidSet;
}

-(nullable IXBeacon*)beaconWithUuid:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;
{
    return self.beacons[[IXBeacon beaconKeyForUuid:uuid major:major.intValue minor:minor.intValue]];
    //    IXBeacon* result = nil;
    //    for (IXBeacon* b in self.beacons) {
    //        if ([uuid isEqualToString:b.uuid]
    //            && [major isEqualToNumber:b.major]
    //            && [minor isEqualToNumber:b.minor] ) {
    //            result = b;
    //            break;
    //        }
    //    }
    //    return result;
}

-(BOOL)isPoi:(NSDictionary*)poi closerToBeacons:(NSArray*)beacons thanPreviousClosestPoi:(NSDictionary*)previousClosestPoi;
{
    return true;
}

-(IXPoi*)poiClosestToBeacons:(NSArray<IXBeacon*>*)currentBeacons;
{
    NSDictionary* result = nil;
    for (NSDictionary* p in self.pois) {
        if ([self isPoi:p closerToBeacons:currentBeacons thanPreviousClosestPoi:result]) {
            result = p;
        }
    }
    return result[@"art"];
}

// entered beacons go into the queue to be added to
/*
 - get beacons on didEnterRegion  -> listOfCurrentBeacons WITHOUT signal strength (purged every 5 sec using timestamp)
 - determine listOfSamplingPois from listOfCurrentBeacons that match poi.beacons
 - if there are pois in listOfSamplingPois then
 go into superSampleMode (2-10Sec Sampling)
 
 - in superSampleMode update the listOfCurrentPois (sorted of proximity)
 from listOfSamplingPois  and the sampled beacons signal strength.
 Pois matching is on the 3 strongest signal strength beacons.
 
 - the above is on the beacon queue
 - the listOfCurrentPois can be subscribed to by VC on the main queue.
 
 operation 
 
 UI ned
 
 EnteringBeaconRegion -> update data.listOfCurrentBeacons
 
 we maintain a list of BeaconsMonitored that should tell us that we enter its region.
 and a list of BeaconsRanged that are detected by monitoring and need ranging (determine proximity).

 
 
 */

- (void)initialBeaconsMonitoringSetup;
{
    self.monitoredBeaconUuidSet = [NSMutableSet set];
    for (NSString* key in self.beacons) {
        [_monitoredBeaconUuidSet addObject:self.beacons[key].UUID];
    }
}

//// operation
//- (BOOL)startMonitoringBeaconsUsingLocationManager:(CLLocationManager*)locationManager;
//{
//    if (! [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
//# warning add alert notification
//        NSLog(@"This device doesn't support beacons' monitoring");
//        return NO;
//    }
//    else {
//        for (NSUUID *beaconUUID in self.monitoredBeaconUuidSet) {
//            CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID
//                                                                              identifier:[beaconUUID UUIDString]];
//           [locationManager startMonitoringForRegion:beaconRegion];
//        }
//        return YES;
//    }
//}

- (void)startRangingBeacon:(CLBeaconRegion *)beaconRegion
{
    // Start monitoring.
    // To get the best accuracy and responsiveness we schedule monitoring and ranging in the same and keep it up for the all app's lifecycle.
//    [self.locationManager startMonitoringForRegion:beacon];
//    [self.locationManager startRangingBeaconsInRegion:beacon];
//    NSLog(@"Monitoring turned on for %@.", beacon.identifier);
}




@end
