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
@end

@implementation IXLocationManager

- (instancetype) initWithDelegate:(id <IXLocationManagerDelegate>)aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
    }
    return self;
}

@end
