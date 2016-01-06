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
#import "IXData.h"
#import "ArtWhisper-Swift.h"

// A way to have string enums in Obj-C
typedef enum {outside, leavingOutside, stopPlaying, startPlaying, inside, leavingInside} state_t;
NSString * const stateAsString[] = {
    [outside] = @"outside",
    [leavingOutside] = @"leavingOutside",
    [stopPlaying] = @"stopPlaying",
    [startPlaying] = @"startPlaying",
    [inside] = @"inside",
    [leavingInside] = @"leavingInside"
};

@interface IXManager ()
@property (nonatomic, strong) IXLocationManager *locationManager;
@property (nonatomic, strong) IXAudioManager *audioManager;
@property (nonatomic, strong) IXData *data;

@property (nonatomic, assign) state_t state;
@property (nonatomic, assign) NSTimeInterval filterSeconds;

@property (nonatomic, strong) NSDate* firstOutside;
@property (nonatomic, strong) NSDate* firstInside;

@property (nonatomic, strong) IXPoi* currentPoi;

@property (nonatomic, strong) OperationQueue *poiQueue;

@end

@implementation IXManager

- (instancetype)initWithDelegate: (id <IXManagerDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        self.poiQueue = [[OperationQueue alloc] init];
        self.delegate = aDelegate;
        self.audioManager = [IXAudioManager sharedAudio];
        [self.locationManager start];
        [self triggerSoundReset];
    }

    return self;
}

- (instancetype) init
{
    return [self initWithDelegate:nil];
}


- (IXLocationManager *) locationManager
{
    if (!_locationManager) {
        _locationManager = [[IXLocationManager alloc] initWithDelegate:self];
        NSAssert(self.poiQueue != nil, @"poiQueue not initialized in %s",__PRETTY_FUNCTION__);
        _locationManager.poiQueue = self.poiQueue;
    }
    return _locationManager;
}

//- (IXAudioManager *) audioManager
//{
//    if (!_audioManager) {
//        _audioManager = [[IXAudioManager alloc] init];
//    }
//    return _audioManager;
//}

- (IXData *) data
{
    if (!_data) {
        _data = [IXData sharedData];
    }
    return _data;
}

- (void) triggerSoundReset {
    self.state = outside;
    self.filterSeconds = 1.0;
    self.firstOutside = [NSDate date];
    self.firstInside = [NSDate date];
}

- (Boolean) isOutsideFiltered {
    NSDate* now = [NSDate date];
    NSTimeInterval timeOutside = [now timeIntervalSinceDate:self.firstOutside];
    return (timeOutside > self.filterSeconds);
}
- (Boolean) isInsideFiltered {
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
            if ([self isOutsideFiltered]) {
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
            if ([self isInsideFiltered]) {
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

#pragma mark - Location Manager Delegate stuff
- (void) ixLocationManager : (IXLocationManager *)ixLocationManager spottedIXBeacon:(IXBeacon *) ixBeacon
{
    if (ixBeacon.distance < 4)
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
        [self.audioManager prepareBackgroundPlayerWithFile:@"filmmuseum human"]; // "background-music-aac"];
        [self.audioManager playBackgroundAudio];
        self.state = inside;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ixManager:stateChange:)]) {
        [self.delegate ixManager:self stateChange:stateAsString[self.state]];
    }
    
    // search for poi near beacon
    IXPoi *newPoi = [[IXData sharedData] poiClosestToBeacons:@[ixBeacon]];
    if (newPoi != self.currentPoi) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ixManager:poiFound:)]) {
            [self.delegate ixManager:self poiFound:newPoi];
        }
        self.currentPoi = newPoi;
    }
    
}
@end
