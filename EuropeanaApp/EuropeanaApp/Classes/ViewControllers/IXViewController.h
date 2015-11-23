//
//  IXViewController.h
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//
/*
    Handles the rudimentary and debug-only user interface to start & stop audio

    OLD, should probably be supplanted
    Currently used for the demo controller
 
 */

#import <UIKit/UIKit.h>

#include "IXManager.h"

@interface IXViewController : UIViewController <IXManagerDelegate>

@end
