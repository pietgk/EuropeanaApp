//
//  IXLocationManager.m
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXLocationManager.h"
#import "IXBeacon.h"
#import "IXData.h"
#import "ArtWhisper-Swift.h"
//#import <CBCentralManager.h>

@import CoreLocation;

@interface IXLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) dispatch_queue_t myQueue;

@property (nonatomic) CLLocationManager *locationManager;

//@property (nonatomic, strong) CBCentralManager *btManager;
//@property (nonatomic, strong) CBPeripheral *peripheral;


@property (nonatomic) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSArray<IXBeacon*> *rangedBeacons;
@property (nonatomic, strong) NSArray<CLBeaconRegion*> *localRegions;
@property (nonatomic, strong) IXData *data;

@end

@implementation IXLocationManager

+ (instancetype)locationManager
{
    static IXLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
//        btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    });
    return sharedLocationManager;
}

- (instancetype)initWithDelegate: (id<IXLocationManagerDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        _delegate = aDelegate;
        
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        // start a monitoring operation using the data from beacons.json
        self.localRegions = [self initialBeaconsRangingSetup];         // beacon range
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (IXData *) data
{
    if (!_data) {
        _data = [IXData sharedData];
    }
    return _data;
}

- (void) start;
{
    [self startRangingBeacons];
    [self askForLocation];
    
}

//[self startRangingBeacons];

//    __weak IXLocationManager* weakSelf = self;
//
//    void (^beaconMonitorBlock)() = ^void(){
//        IXData *data = [IXData sharedData];
//        if (! [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
//            NSLog(@"This device doesn't support beacons' monitoring");
//        }
//        else {
//            for (NSUUID *beaconUUID in data.monitoredBeaconUuidSet) {
//                CLBeaconRegion* beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID
//                                                                                  identifier:[beaconUUID UUIDString]];
//                [weakSelf startMonitoringForRegion:beaconRegion];
//            }
//            return YES;
//        }
//        [[IXData sharedData] initialBeaconsMonitoringSetup];
//    };
//    BlockOperation* beaconMonitorOperation = [[BlockOperation alloc] initWithBlock:beaconMonitorBlock];
//
//
//    void (^beaconRangingBlock)() = ^void(){
//        [[IXData sharedData] initialBeaconsMonitoringSetup];
//    };
//[_operationQueue addOperation:monitorOperation]

- (NSArray *)initialBeaconsRangingSetup
{
    // For now we retrieve all the beacons' asset from a convenience PLIST
    NSArray *localRegions = [[IXData sharedData] localRegions];

    for (CLBeaconRegion *region in localRegions) {
        
        
        // The identifier is a value used to identify this region inside the application. For now we are retrieving it form the plist but maybe we can have a unique identifier to identify all the assets by set a string = major *append* minor
//        [regionResult addObject:region];
        
        // new: add as beacon, for more precise ranging
//        IXBeacon *beacon = [[IXBeacon alloc] initWithDictionary:elem];
//        [beaconResult addObject:beacon];
    }
    // but add these to data as well:
//    [[IXData sharedData] setBeaconArray:beaconResult];
    
    return [[IXData sharedData] localRegions];
}


//- (NSArray *)initialBeaconsRangingSetupPlist
//{
//    // For now we retrieve all the beacons' asset from a convenience PLIST
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"plist"];
//    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
//    
//    NSMutableArray *regionResult = [NSMutableArray array];
//    NSMutableArray *beaconResult = [NSMutableArray array];
//    
//    for (NSDictionary *elem in plistArray) {
//        // add as region, for now
//        CLBeaconRegion *region = [[CLBeaconRegion alloc]
//                                  initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:elem[@"UUID"]]
//                                  major:[elem[@"major"] integerValue]
//                                  minor:[elem[@"minor"] integerValue]
//                                  identifier:elem[@"identifier"]];
//        
//        
//        // The identifier is a value used to identify this region inside the application. For now we are retrieving it form the plist but maybe we can have a unique identifier to identify all the assets by set a string = major *append* minor
//        [regionResult addObject:region];
//        
//        // new: add as beacon, for more precise ranging
//        IXBeacon *beacon = [[IXBeacon alloc] initWithDictionary:elem];
//        [beaconResult addObject:beacon];
//    }
//    // but add these to data as well:
//    [[IXData sharedData] setBeaconArray:beaconResult];
//
//    return regionResult;
//}

- (BOOL)startRangingBeacons
{
    // Check for requested device's capabilities
    if (! [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        // TO DISCUSS
        NSLog(@"This device doesn't support beacons' monitoring");
        return NO;
    } else {
        for (CLBeaconRegion *region in self.localRegions) {
            [self startRangingRegion:region];
        }
        
        return YES;
    }
}

- (void)startRangingRegion:(CLBeaconRegion *)region
{
    // Start monitoring.
    // To get the best accuracy and responsiveness we schedule monitoring and ranging in the same and keep it up for the all app's lifecycle.
    [self.locationManager startMonitoringForRegion:region];
    [self.locationManager startRangingBeaconsInRegion:region];
    NSLog(@"Monitoring turned on for %@.", region.identifier);
}

#pragma mark - Location manager delegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways: {
            NSLog(@"LOCATION always AUTHORIZED");
            // Notify that the user has granted access to location service
        }   break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            NSLog(@"LOCATION when in use AUTHORIZED");
            // Notify that the user has granted access to location service
        }   break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            NSLog(@"LOCATION DENIED");
            // Show error message
        } break;
        default:
            // Location undefined
            break;
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"IXLocationMnager error: %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside: {
            // Inform the delegate for inside region event.
            if (self.delegate && [self.delegate respondsToSelector:@selector(ixLocationManger:enteredAssetRegion:)]) {
                [self.delegate ixLocationManger:self enteredAssetRegion:region];
            }
        }   break;
        case CLRegionStateOutside:
        case CLRegionStateUnknown:{
            // Inform the delegate for outside region event.
            if (self.delegate && [self.delegate respondsToSelector:@selector(ixLocationManager:exitedAssetRegion:)]) {
                [self.delegate ixLocationManager:self exitedAssetRegion:region];
            }
        } break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([beacons count] > 0) {
        // To keep it simple we rely on Apple accuracy algorithm. Soon I'll checkout something more accurate but should be fine for hackathon demo app.

        // Before we inspect all the ranged beacons let's clean up all the beacons that have unknown distance.
        NSArray *validBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CLBeacon *evaluatedBeacon, NSDictionary *bindings) {
            return evaluatedBeacon.rssi != 0; //or accuracy == -1.0 or proximity == Unknown
        }]];
        
        
        // Inform the delegate of all the foundend beacons.
        // Note: A beacon region could contains several beacons (in musuem exposition we could have different beacons just to index the room not a one-to-one relationship between beacon and asset)
        for (CLBeacon *currentBeacon in validBeacons) {
            
            NSLog(@"Beacons identifier: %@ major: %@ minor %@ distance: %@",region.identifier, currentBeacon.major, currentBeacon.minor, @(currentBeacon.accuracy));
            IXBeacon *ixBeacon = [IXBeacon createWithIdentifier:region.identifier major:[currentBeacon.major integerValue] minor:[currentBeacon.minor integerValue] distance:currentBeacon.accuracy];
            if (self.delegate && [self.delegate respondsToSelector:@selector(ixLocationManager:spottedIXBeacon:)]) {

                
                //if (currentBeacon.accuracy < 4) { // hard coded 4m for hackaton
                // 20150106 temp disable delegating info to the manager, as we are switching to queues
               // [self tellDelegateBeaconIsSpotted:ixBeacon];
                 //}
            }
            // 2015: we probably need to add beacons to a queue and have a bg task determine where we are in the position of artworks
            // NEW:
            // Add the beacon to the operationQueue as a HandleRangedBeaconOperation
            HandleRangedBeaconOperation *op = [[HandleRangedBeaconOperation alloc] initWithBeacon:ixBeacon];
            [self.operationQueue addOperation:op];
        }
    }
}

- (void) tellDelegateBeaconIsSpotted:(IXBeacon*)beacon
{
    NSLog(@"Beacon major: %@ minor %@ ", beacon.major, beacon.minor);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(ixLocationManager:spottedIXBeacon:)]) {
            [self.delegate ixLocationManager:self spottedIXBeacon:beacon];
        }
    });
}



- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    // Handle error
    NSLog(@"%@",error);
}


/*
 We can use a `LocationOperation` to retrieve the user's current location.
 Once we have the location, we can compute how far they currently are
 from the epicenter of the earthquake.
 
 If this operation fails (ie, we are denied access to their location),
 then the text in the `UILabel` will remain as what it is defined to
 be in the storyboard.
 */
- (void) askForLocation
{
    LocationOperation *locationOperation = [[LocationOperation alloc] initWithAccuracy:kCLLocationAccuracyBestForNavigation locationHandler:^(CLLocation * _Nonnull location) {
        if (location != nil) {
        }
    }];
    
    [self.operationQueue addOperation:locationOperation];
}


#pragma mark - CoreBluetooth

//[self.manager scanForPeripheralsWithServices:nil options:options];

@end
