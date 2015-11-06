//
//  IXEnteringBeaconRegion.h
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 02/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXBeacon.h"

@protocol BeaconDelegate;

@interface IXEnteringBeaconRegion : NSOperation

@property (nonatomic, readonly, strong, nonnull) IXBeacon *beacon;
@property (nonatomic, assign, nonnull) id<BeaconDelegate> delegate;

- (nonnull instancetype)initWithBeacon:(nonnull IXBeacon *)beacon delegate:(nullable id<BeaconDelegate>) theDelegate;

@end

@protocol BeaconDelegate <NSObject>
- (void)enteringBeaconRegionDidFinish:(nonnull IXEnteringBeaconRegion *)operation;
@end