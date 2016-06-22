//
//  IXData.m
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 28/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

/* 
 Refactor into swift, then use extensions to add items to the local datastores.
 Should we not use something like Realm instead of some simple data structures?
 
 
 */

#import "IXData.h"
#import "IXBeacon.h"
#import "IXPoi.h"
#import "ArtWhisper-Swift.h"

@interface IXData ()

@property (nonatomic, strong) NSMutableSet<NSUUID*> *monitoredBeaconUuidSet;

@property (nonatomic, strong) NSMutableDictionary<NSString*,IXBeacon *> *beaconsRanged; // key is uuid_major_minor

@property (nonatomic, strong, nullable) NSMutableDictionary <NSString*,IXBeacon *> *beacons;
@property (nonatomic, strong) NSMutableArray<IXPoi *> *pois;            // external interface should be Array
@property (nonatomic, strong) NSMutableArray<IXHistoricPoi *> *historicPois;
@property (nonatomic, strong) NSArray<IXPoi *> *suggestions;
@property (nonatomic, strong) NSArray<CLBeaconRegion *> *localRegions;

// history should be related to a list of venues, but we do not have that yet.
@property (nonatomic, strong) NSArray<IXPoi *> *poiHistory;
@end

@implementation IXData
@synthesize beacons=_beacons, pois=_pois, suggestions = _suggestions;

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

// MARK: Mock data
- (IXPoi  * _Nonnull) internalMockPoi:(BOOL)nextValue
{
    static int index = -1;
    if (nextValue) {
        if (++index >= self.pois.count) {
            index = 0;
        }
    } else {    // previous version
        if (--index < 0) {
            index = (int)self.pois.count - 1;
        }
    }
    IXPoi *newPoi = self.pois[index];
    return newPoi;
}

- (IXPoi  * _Nonnull) mockPoi
{
    return [self internalMockPoi:YES];
}
- (IXPoi  * _Nonnull) previousMockPoi
{
    return [self internalMockPoi:NO];
}

- (NSArray *) pois
{
    if (!_pois) {
        _pois = [NSMutableArray arrayWithArray:[self poisFromResourceFile]];
    }
    return _pois;
}

- (void) addPoi:(IXPoi *)newPoi
{
    [self.pois addObject:newPoi];
}

- (NSArray *) suggestions
{
    if (!_suggestions) {
        _suggestions = [self suggestionsFromResourceFile];
    }
    return _suggestions;
}

-(NSMutableDictionary<NSString*,IXBeacon *>*)beaconsFromResourceFile;
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
    NSError *error;
    
    // Glimworm beacons.json from http://85.17.193.165:1880/beacons/
    // plus Hermitage 2015: tentoonstelling v.h. Amsterdam Museum: Hollanders van de Gouden Eeuw
    NSString *path = [[NSBundle mainBundle] pathForResource:@"poi" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (error) {
        NSLog(@"Error parsing poi.json: %@", error);
        return nil;
    }
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

-(NSArray*)suggestionsFromResourceFile;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"suggestions" ofType:@"json"];
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

/** returns an array of local (...) regions, calculated and mapped from the beacons list and cached */
- (NSArray *) localRegions
{
    if (!_localRegions) {
        NSMutableDictionary *newRegions = [NSMutableDictionary new];
        for (NSString *key in self.beacons) {
            IXBeacon *beacon = self.beacons[key];
            CLBeaconRegion *region = [[CLBeaconRegion alloc]
                              initWithProximityUUID:beacon.UUID
                              identifier:beacon.uuid];
            newRegions[beacon.uuid] = region;           // either uuid or key, depending on what works
        }
        _localRegions = [newRegions allValues];
    }
    return _localRegions;
}
// MARK: Beacons

- (void) setBeaconArray:(NSArray <IXBeacon *>* _Nonnull) newBeacons
{
    NSMutableDictionary<NSString*,IXBeacon *>* newBeaconDict = [NSMutableDictionary dictionaryWithCapacity:[newBeacons count]];
    for (IXBeacon *beacon in newBeacons) {
        [newBeaconDict addEntriesFromDictionary: @{beacon.key:beacon} ];
    }
    _beacons = newBeaconDict;
}

- (NSDictionary<NSString*,IXBeacon *>*) beacons;
{
    if (!_beacons) {
        _beacons = [self beaconsFromResourceFile];
    }
    return [NSDictionary dictionaryWithDictionary:_beacons];
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

// MARK: - History of POIs and venues
- (NSMutableArray *) historicPois
{
    if (!_historicPois) {
        _historicPois = [self loadHistoricPois];
        if (!_historicPois) {
            _historicPois = [[NSMutableArray alloc] init];
        }
    }
    return _historicPois;
}

// used mostly for debugging purposes
- (void) clearHistoricPois
{
    self.historicPois = nil;
}
- (void) addHistoricPoi:(IXHistoricPoi  * _Nonnull ) hPoi
{
//    if ([self poiIsHistoricPoi:hPoi.poi]) {         // this, or use an NSSet or NSDict
//        [self.historicPois removeObject:hPoi];
//    }
    [self.historicPois addObject:hPoi];
}

- (BOOL) poiIsHistoricPoi:(IXPoi * _Nonnull) poi
{
    for (IXHistoricPoi* hp in self.historicPois) {
#warning IXPoi does not have a unique ID yet
        if (hp.poi == poi) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *) loadHistoricPois
{
    NSString *path = @"~/awhistoricpois.plist";
    NSString *fullPath = [path stringByExpandingTildeInPath];
    if ([[NSFileManager defaultManager] isReadableFileAtPath:fullPath]) {
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        if (data) {
            NSError *error;
//            NSObject *blob = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            NSObject *blob = [unarchiver decodeTopLevelObjectAndReturnError:&error];
            if ([[blob class] isSubclassOfClass:[NSArray class]]) {
                NSMutableArray *hisPois = [[NSMutableArray alloc] initWithArray:blob];
                return hisPois;
            }
            [unarchiver finishDecoding];
            unarchiver = nil;
        }
    }
    return nil;
}

- (void) saveHistoricPois
{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSError *error;
        NSString *path = @"~/awhistoricpois.plist";
        NSString *fullPath = [path stringByExpandingTildeInPath];
        NSData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeRootObject:self.historicPois];
        [archiver finishEncoding];
        BOOL result = [data writeToFile:fullPath atomically:YES];
//        NSData *data = [NSJSONSerialization dataWithJSONObject:self.historicPois options:NSJSONWritingPrettyPrinted error:&error];
        if (!result) {
            NSLog(@"error during writing of historic pois");
        }
        archiver = nil;
        [data writeToFile:fullPath atomically:YES];
    });
}

// TODO: probably kick of some operation which handles the found beacon(s)
-(void) addRangedBeacon:(IXBeacon *)newBeacon
{
    if (newBeacon) {
        self.beaconsRanged[newBeacon.key] = newBeacon;
        NSNotification *notification = [[NSNotification alloc] initWithName:kRangedBeaconAddedNotification object:newBeacon userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

-(BOOL)isPoi:(IXPoi*)poi closerToBeacons:(NSArray*)beacons thanPreviousClosestPoi:(IXPoi*)previousClosestPoi;
{
    // check beacons of poi and previouspoi, determine if there is an overlap with beacons
    return true;
}

// this can probably be highly optimised, no?
-(IXPoi*)poiClosestToBeacons:(NSArray<IXBeacon*>*)currentBeacons;
{
    IXPoi* result = nil;
    for (IXPoi* p in self.pois) {
        if ([self isPoi:p closerToBeacons:currentBeacons thanPreviousClosestPoi:result]) {
            result = p;
        }
    }
    return result;
}

-(NSArray <IXPoi*>*)poisOfBeacon:(IXBeacon *)aBeacon;
{
    NSMutableArray<IXPoi*> *result = [[NSMutableArray alloc] init];
    
    for (IXPoi* p in self.pois) {
        if ([p containsBeacon:aBeacon]) {
            [result addObject:p];
        }
    }
    
    return [NSArray arrayWithArray:result];
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

#pragma mark - json export
- (void) beaconExport:(NSDictionary<NSString*,IXBeacon *>*) beacons
{
    NSError *error;
    NSString *path = @"~/awbeacons.json";
    NSString *fullPath = [path stringByExpandingTildeInPath];
    NSData *data = [NSJSONSerialization dataWithJSONObject:beacons options:NSJSONWritingPrettyPrinted error:&error];
    [data writeToFile:fullPath atomically:YES];
}

- (void) poiExport:(NSMutableArray<IXPoi *>*) pois
{
    NSError *error;
    NSString *path = @"~/awpois.json";
    NSString *fullPath = [path stringByExpandingTildeInPath];
    NSData *data = [NSJSONSerialization dataWithJSONObject:pois options:NSJSONWritingPrettyPrinted error:&error];
    [data writeToFile:fullPath atomically:YES];
}

@end
