//
//  IXAppDelegate.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "ArtWhisper-Swift.h"

@interface IXAppDelegate ()
@property (weak, nonatomic) IBOutlet IXTabBarController *tabBarController;

@end
@implementation IXAppDelegate

// @synthesize manager=_manager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // the manager takes care of location and ibeacon queues.
    self.manager = [[IXManager alloc] init];
    [Fabric with:@[[Crashlytics class]]];
    // TODO: Move this to where you establish a user session
    [self logUser];

    if ([[self.window rootViewController] isKindOfClass:[IXTabBarController class]]) {
        self.tabBarController = (IXTabBarController *)[self.window rootViewController];
    } else {
        NSAssert(true, @"Rootview is not tabbar");
    }
//    [UIFont dumpAllFonts];
    return YES;
}

- (void) logUser {
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"12345"];
    [CrashlyticsKit setUserEmail:@"user@fabric.io"];
    [CrashlyticsKit setUserName:@"Test User"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - lazy properties
- (IXManager *) manager
{
    if (!_manager) {
        _manager = [[IXManager alloc] init];
    }
    return _manager;
}

//- (IXAudioManager *) audioManager
//{
//    if (!_audioManager) {
//        _audioManager = [[IXAudioManager alloc] init];
//    }
//    return _audioManager;
//}

#pragma mark delegate protocol
// this should be done through the IXManager, no?
- (void) showActiveGuideWithPoi:(IXPoi *)poi
{
    if ([self.tabBarController selectedIndex] != 3) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id vc = [self.tabBarController showActiveGuide];
        #warning protocolize!
            if ([[vc class] isSubclassOfClass:[IXActiveGuideVC class]] ) {
                IXActiveGuideVC *ag = (IXActiveGuideVC *)vc;
                if (![ag playing] && ag.poi != poi) {
                    ag.poi = poi;
                    [ag startPlaying];
                } // else discard
            }
                           });
    } else {
//         NSLog(@"already selected activeguide");
    }
}

@end
