//
//  IXBeacon.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXBeacon.h"

@implementation IXBeacon

+ (instancetype) createWithIdentifier:(NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance;
{
    return [[self alloc]initWithIdentifier:identifier major:major minor:minor distance:distance];
}

- (instancetype) initWithIdentifier:(NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance
{
    self = [super init];
    
    if (self) {
        self.extraInfo = [NSMutableArray array];
        self.identifier = identifier;
        self.major = [NSNumber numberWithInteger:major];
        self.minor = [NSNumber numberWithInteger:minor];
        self.distance = distance; //OR convenience algorithm to improve distance accuracy (the one provided by Apple is a little bit shitty)
    }
    
    return self;
}

+ (instancetype) createWithDictionary:(nonnull NSDictionary *)newDict
{
    return [[self alloc] initWithDictionary:newDict];
}

- (instancetype) initWithDictionary:(nonnull NSDictionary *)newDict
{
    self = [super init];
    
    if (self) {
        self.extraInfo = [NSMutableArray array];

        [newDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            @try {
                [self setValue:obj forKey:key];
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        }];
        
    }
    return self;
}

- (NSString *) uniqueKey
{
    return [NSString stringWithFormat:@"%@_%05d_%05d",self.uuid, self.major.intValue, self.minor.intValue];
}
            
- (CGFloat)realDistance
{
    // New distance's algotrithm
    return -1.0f;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> uuid:%@ (%@,%@)",self.class, self, self.uuid, self.major, self.minor];
}

@end
