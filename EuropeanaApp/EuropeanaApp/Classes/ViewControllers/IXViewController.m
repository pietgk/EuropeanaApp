//
//  IXViewController.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXViewController.h"
#import "IXAppDelegate.h"

@interface IXViewController ()
- (IBAction)test:(id)sender;

@property (nonatomic, strong) IXManager *manager;
@end

@implementation IXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = APPDelegate.manager;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender
{
    IXBeacon *ixBeacon = [[IXBeacon alloc] init];
    [self.manager ixLocationManager:nil spottedIXBeacon:ixBeacon];
}
@end
