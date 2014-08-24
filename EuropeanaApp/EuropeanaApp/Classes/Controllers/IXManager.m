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

typedef enum {outside, leavingOutside, stopPlaying, startPlaying, inside, leavingInside} state_t;

@interface IXManager ()
@property (nonatomic, strong) IXLocationManager *locationManager;
@property (nonatomic, strong) IXAudioManager *audioManager;

@property (nonatomic, assign) state_t state;
@property (nonatomic, assign) NSTimeInterval filterSeconds;

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
    self.filterSeconds = 5.0;
    self.firstOutside = [NSDate date];
    self.firstInside = [NSDate date];
}

- (Boolean) isOutsideFor5s {
    NSDate* now = [NSDate date];
    NSTimeInterval timeOutside = [now timeIntervalSinceDate:self.firstOutside];
    return (timeOutside > self.filterSeconds);
}
- (Boolean) isInsideFor5s {
    NSDate* now = [NSDate date];
    NSTimeInterval timeInside = [now timeIntervalSinceDate:self.firstInside];
    return (timeInside > self.filterSeconds);
}

- (void) weDetectedOutside {
    switch (self.state) {
        case inside:
            self.state = leavingInside;
            self.firstOutside = [NSDate date];
            break;
        case leavingInside:
            if ([self isOutsideFor5s]) {
                self.state = stopPlaying;
            }
            break;
        case outside:
            break;
        case leavingOutside:
            self.state = outside;
            break;
        default:
            break;
    }
}

- (void) weDetectedInside {
    switch (self.state) {
        case outside:
            self.state = leavingOutside;
            self.firstInside = [NSDate date];
            break;
        case leavingOutside:
            if ([self isInsideFor5s]) {
                self.state = startPlaying;
            }
            break;
        case inside:
            break;
        case leavingInside:
            self.state = inside;
            break;
        default:
            break;
    }
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
    if (ixBeacon.distance < 5)
    {
        [self weDetectedInside];
    } else {
        [self weDetectedOutside];
    }
    if (self.state == stopPlaying) {
        [self.audioManager fadeOutBackgroundAudio];
        self.state = outside;
    }
    if (self.state == startPlaying) {
        [self.audioManager prepareBackgroundPlayerWithFile:@"filmmuseum human.caf"]; // "background-music-aac"];
        [self.audioManager playBackgroundAudio];
        self.state = inside;
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
