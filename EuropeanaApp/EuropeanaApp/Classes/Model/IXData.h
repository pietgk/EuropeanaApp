//
//  IXData.h
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 28/10/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IXBeacon.h"

@interface IXData : NSObject

-(IXBeacon*)beaconWithUuid:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;

@end
