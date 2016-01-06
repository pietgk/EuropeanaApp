//
//  IXAppDelegate.h
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IXManager.h"
#import "IXAudioManager.h"

@interface IXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IXManager *manager;
@property (strong, nonatomic) IXAudioManager *audioManager;

- (void) showActiveGuideWithPoi:(IXPoi *)poi;

@end
