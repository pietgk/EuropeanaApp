//
//  IXManager.h
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//
/* OLD, should probably be supplanted
    Currently used for the demo controller
 
 */
#import <Foundation/Foundation.h>
#import "IXLocationManager.h"
#import "IXPoi.h"

@class IXManager;

@protocol IXManagerDelegate <NSObject>
- (void) ixManager: (IXManager *)ixManager stateChange: (NSString *)newState;
- (void) ixManager: (IXManager *)ixManager poiFound: (IXPoi *)poi;
@end

@interface IXManager : NSObject  <IXLocationManagerDelegate>

- (instancetype)initWithDelegate: (id<IXManagerDelegate>) aDelegate;

@property (nonatomic, weak) id<IXManagerDelegate> delegate;

@end
