//
//  IXBeacon.h
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXBeacon : NSObject
@property (nonatomic, assign) NSUInteger major;
@property (nonatomic, assign) NSUInteger minor;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, copy) NSString *identifier;

+ (instancetype) createWithIdentifier:(NSString *)identifier major:(NSUInteger)major minor:(NSUInteger)minor distance:(CGFloat) distance;
@end
