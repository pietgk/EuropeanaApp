//
//  IXEnteringBeaconRegion.m
//  EuropeanaApp
//
//  Created by W.J. Groot Kormelink on 02/11/15.
//  Copyright © 2015 Phluxus. All rights reserved.
//

#import "IXEnteringBeaconRegion.h"

@interface handleRangedBeacon ()
@property (nonatomic, readwrite, strong) IXBeacon *beacon;
@end

@implementation IXEnteringBeaconRegion

- (nonnull instancetype)initWithBeacon:(nonnull IXBeacon *)beacon delegate:(nullable id<BeaconDelegate>) theDelegate;
{
    if (self = [super init]) {
        self.delegate = theDelegate;
        self.beacon = beacon;
    }
    return self;
}

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        //NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.photoRecord.URL];
        
//        if (self.isCancelled) {
//            imageData = nil;
//            return;
//        }
//        
//        if (imageData) {
//            UIImage *downloadedImage = [UIImage imageWithData:imageData];
//            self.photoRecord.image = downloadedImage;
//        }
//        else {
//            self.photoRecord.failed = YES;
//        }
//        
//        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(enteringBeaconRegionDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

@end
