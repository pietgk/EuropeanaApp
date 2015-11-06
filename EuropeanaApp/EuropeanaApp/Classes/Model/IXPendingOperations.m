//
//  IXPendingOperations.m
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 01/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import "IXPendingOperations.h"

@implementation IXPendingOperations

- (NSOperationQueue *)poiQueue {
    if (!self.poiQueue) {
        self.poiQueue = [[NSOperationQueue alloc] init];
        self.poiQueue.name = @"poi Queue";
        self.poiQueue.maxConcurrentOperationCount = 1;
    }
    return self.poiQueue;
}

@end
