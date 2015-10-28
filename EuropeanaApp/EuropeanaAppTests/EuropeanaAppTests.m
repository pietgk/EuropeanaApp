//
//  EuropeanaAppTests.m
//  EuropeanaAppTests
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IXManager.h"
#import "IXLocationManager.h"
#import "IXBeacon.h"
#import "IXAudioManager.h"
#import "IXData.h"

@interface EuropeanaAppTests : XCTestCase
@property (nonatomic, strong) IXManager *manager;
@property (nonatomic, strong) IXLocationManager *locationManager;
@property (nonatomic, strong) IXBeacon *ixBeacon;
@property (nonatomic, strong) IXAudioManager *ixAudioManager;
@end

@implementation EuropeanaAppTests

- (void)setUp
{
    [super setUp];
    self.ixBeacon = [[IXBeacon alloc] init];
    self.manager = [[IXManager alloc] init];
//    self.locationManager = [[IXLocationManager alloc] initWithDelegate:self.manager];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBeacon
//
{// - (void) ixLocationManager : (IXLocationManager *)ixLocationManager spottedIXBeacon:(IXBeacon *) ixBeacon

    [self.manager ixLocationManager:nil spottedIXBeacon:self.ixBeacon];
    
}

-(void)testBeaconsFromfile
{
    IXData* data = [[IXData alloc] init];
    NSDictionary* beacon = [data beaconWithUuid:@"" major:@100 minor:@66];
    XCTAssertNotNil(beacon, @"there should be a beacon");
    XCTAssert([@100 isEqualToNumber:beacon[@"major"]] , @"the major should match");
    XCTAssert([@66 isEqualToNumber:beacon[@"minor"]] , @"the major should match");
}

@end
