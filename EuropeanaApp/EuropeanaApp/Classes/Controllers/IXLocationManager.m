//
//  IXLocationManager.m
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXLocationManager.h"
#import "IXBeacon.h"

@interface IXLocationManager ()
@property (nonatomic, strong) id <IXLocationManagerDelegate> delegate;
@property (nonatomic, strong) dispatch_queue_t myQueue;
@end

@implementation IXLocationManager

- (instancetype) initWithDelegate:(id <IXLocationManagerDelegate>)aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        self.myQueue = dispatch_queue_create("MyQueue",NULL);
    }
    return self;
}

- (void) start;
{
    dispatch_async(self.myQueue, ^{
        // Perform ...
        NSUInteger major = 3001;
        NSUInteger minor = 1;

        dispatch_async(dispatch_get_main_queue(), ^{
            IXBeacon *beacon = [[IXBeacon alloc] init];
            beacon.major = major;
            beacon.minor = minor;
            if (self.delegate && [self.delegate respondsToSelector:@selector(ixLocationManager:spottedIXBeacon:)]) {
                [self.delegate ixLocationManager:self spottedIXBeacon:beacon];
            }
        });
    });
    
}

//- (void) ixLocationManger : (IXLocationManager *)ixLocationManager exitAssetRegion:(IXBeacon *) ixBeacon
//- (void) ixLocationManager : (IXLocationManager *)ixLocationManager enteredIXBeaconRegion: (IXBeacon *) ixBeacon

@end
