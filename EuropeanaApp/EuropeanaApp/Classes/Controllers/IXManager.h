//
//  IXManager.h
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXLocationManager.h"

@class IXManager;

@protocol IXManagerDelegateProtocol <NSObject>
- (void) ixManager: (IXManager *)ixManager stateChange: (NSString *)newState;
@end

@interface IXManager : NSObject  <IXLocationManagerDelegate>

- (instancetype)initWithDelegate: (id<IXManagerDelegateProtocol>) delegate;

@end
