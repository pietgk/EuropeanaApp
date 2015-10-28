//
//  IXData.m
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 28/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import "IXData.h"

@implementation IXData {
    NSArray* beacons;
}

+ (IXData*)sharedData {
    static IXData *myData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myData = [[self alloc] init];
    });
    return myData;
}

- (instancetype)init {
    if (self = [super init]) {
        self->beacons = [self beaconsFromResourceFile];
    }
    return self;
}

-(NSArray*)beaconsFromResourceFile;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beacons" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    return jsonArray;
}

-(NSDictionary*)beaconWithUuid:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;
{
    NSDictionary* result = nil;
    // todo uuid
    for (NSDictionary*b in self->beacons) {
        if ([major isEqualToNumber:b[@"major"]]
            && [minor isEqualToNumber:b[@"minor"]] ) {
            result = b;
            break;
        }
    }
    return result;
}

@end
