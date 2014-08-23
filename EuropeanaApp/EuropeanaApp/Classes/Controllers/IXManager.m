//
//  IXManager.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXManager.h"
#import "IXLocationManager.h"
#import "IXBeacon.h"
#import "IXAudioManager.h"

@interface IXManager ()
@property (nonatomic, strong) IXLocationManager *locationManager;
@property (nonatomic, strong) IXAudioManager *audioManager;
@end

@implementation IXManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.locationManager start];
    }
    return self;
}

- (IXLocationManager *) locationManager
{
    if (!_locationManager) {
        _locationManager = [[IXLocationManager alloc] initWithDelegate:self];
    }
    return _locationManager;
}


- (IXAudioManager *) audioManager
{
    if (!_audioManager) {
        _audioManager = [[IXAudioManager alloc] init];
    }
    return _audioManager;
}

#pragma mark - Location Manager Delegate stuff
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager spottedIXBeacon:(IXBeacon *) ixBeacon
{
    [self.audioManager tryPlayMusic];
}
/*
 *
 */
- (void) ixLocationManger : (IXLocationManager *)ixLocationManager exitAssetRegion:(IXBeacon *) ixBeacon;
{
    
}
/*
 *
 */
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager enteredIXBeaconRegion: (IXBeacon *) ixBeacon;
{
    
}
@end
