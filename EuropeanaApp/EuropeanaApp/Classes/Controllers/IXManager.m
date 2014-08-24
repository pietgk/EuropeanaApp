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

typedef enum {outside, leavingOutside, stopPlaying, inside, leavingInside, startPlaying} state_t;

@interface IXManager ()
@property (nonatomic, strong) IXLocationManager *locationManager;
@property (nonatomic, strong) IXAudioManager *audioManager;

@property (nonatomic, assign) state_t state;
@property (nonatomic, assign) NSTimeInterval filterSeconds;
@property (nonatomic, assign) NSTimeInterval triggerAtSeconds;

@property (nonatomic, strong) NSDate* firstOutside;
@property (nonatomic, strong) NSDate* firstInside;

@end

@implementation IXManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.locationManager start];
        [self triggerSoundReset];
    }
    return self;
}

- (void) triggerSoundReset {
    self.state = outside;
    self.triggerAtSeconds = 5.0;
    self.firstOutside = [NSDate date];
    self.firstInside = [NSDate date];
}

- (Boolean) isOutside {
    NSDate* now = [NSDate date];
    NSTimeInterval timeOutside = [now timeIntervalSinceDate:self.firstOutside];
    return (timeOutside > self.filterSeconds);
}
- (Boolean) isInside {
    NSDate* now = [NSDate date];
    NSTimeInterval timeInside = [now timeIntervalSinceDate:self.firstInside];
    return (timeInside > self.filterSeconds);
}

- (void) weAreOutside {
    
}
//

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
    if (ixBeacon.distance < 5)
    {
        [self.weAreInside];
        
    } else {
        [self.weAreOutside];
    }
    if (self.state == startPlaying)
    {
        [self.audioManager startPlay];
    }
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
