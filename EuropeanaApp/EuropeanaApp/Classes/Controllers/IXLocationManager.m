//
//  IXLocationManager.m
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXLocationManager.h"
#import "IXBeacon.h"
@import CoreLocation;

@interface IXLocationManager ()<CLLocationManagerDelegate>
//@property (nonatomic, strong) id <IXLocationManagerDelegate> delegate;
@property (nonatomic, strong) dispatch_queue_t myQueue;

@property (nonatomic) CLLocationManager *locationManager;

/**
 *  Contains every ranged beacons mapped from plist file.
 */
@property (nonatomic) NSArray *rangedBeacons;

@end

@implementation IXLocationManager

+ (instancetype)locationManager
{
    static IXLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}

- (instancetype)initWithDelegate: (id<IXLocationManagerDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.rangedBeacons = [self initialBeaconsRangingSetup];
        
    }
    return self;
}

- (void) start;
{
    [self startRangingBeacons];
}

- (NSArray *)initialBeaconsRangingSetup
{
    // For now we retrieve all the beacons' asset from a convenience PLIST
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *elem in plistArray) {
        CLBeaconRegion *beacon = [[CLBeaconRegion alloc]
                                             initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:elem[@"UUID"]]
                                             major:[elem[@"major"] integerValue]
                                             minor:[elem[@"minor"] integerValue]
                                             identifier:elem[@"identifier"]];
        
        // The identifier is a value used to identify this region inside the application. For now we are retrieving it form the plist but maybe we can have a unique identifier to identify all the assets by set a string = major *append* minor
        
        [result addObject:beacon];
    }
    
    return result;
}

- (BOOL)startRangingBeacons
{
    // Check for requested device's capabilities
    if (! [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        // TO DISCUSS
        NSLog(@"This device doesn't support beacons' monitoring");
        return NO;
    }
    else {
        for (CLBeaconRegion *beacon in self.rangedBeacons) {
            [self startRangingBeacon:beacon];
        }
        
        return YES;
    }
}

- (void)startRangingBeacon:(CLBeaconRegion *)beacon
{
    // Start monitoring.
    // To get the best accuracy and responsiveness we schedule monitoring and ranging in the same and keep it up for the all app's lifecycle.
    [self.locationManager startMonitoringForRegion:beacon];
    [self.locationManager startRangingBeaconsInRegion:beacon];
    NSLog(@"Monitoring turned on for %@.", beacon.identifier);
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(ixLocationManager:spottedIXBeacon:)]) {

                // 2015: we probably need to add beacons to a queue and have a bg task determine where we are in the position of artworks
                
                //if (currentBeacon.accuracy < 4) { // hard coded 4m for hackaton
                    IXBeacon *ixBeacon = [IXBeacon createWithIdentifier:region.identifier major:[currentBeacon.major integerValue] minor:[currentBeacon.minor integerValue] distance:currentBeacon.accuracy];
                        [self tellDelegateBeaconIsSpotted:ixBeacon];
                //}
            }
        }
    }
}

- (void) tellDelegateBeaconIsSpotted:(IXBeacon*)beacon
{
    NSLog(@"Beacon major: %lu minor %lu ", beacon.major, (unsigned long)beacon.minor);
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

@end
