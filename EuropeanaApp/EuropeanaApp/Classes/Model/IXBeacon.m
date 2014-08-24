//
//  IXBeacon.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXBeacon.h"

@implementation IXBeacon

+ (instancetype) createWithUUID:(NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance;
{
    return [[self alloc]initWithIdentifier:identifier major:major minor:minor distance:distance];
}

- (instancetype) initWithIdentifier:(NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance
{
    self = [super init];
    
    if (self) {
        self.identifier = identifier;
        self.major = major;
        self.minor = minor;
        self.distance = distance; //OR convenience algorithm to improve distance accuracy (the one provided by Apple is a little bit shitty)
    }
    
    return self;
}

- (CGFloat)realDistance
{
    // New distance's algotrithm
    return -1.0f;
}

@end
