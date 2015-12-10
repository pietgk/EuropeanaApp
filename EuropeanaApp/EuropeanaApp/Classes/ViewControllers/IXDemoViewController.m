//
//  IXDemoViewController.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXDemoViewController.h"
#import "IXAppDelegate.h"
#import "IXAudioManager.h"
#import "IXData.h"
#import "CBBeaconsMap.h"
#import "ArtWhisper-swift.h"

@interface IXDemoViewController ()
- (IBAction)test:(id)sender;
- (IBAction)speak:(id)sender;
- (IBAction)stop:(id)sender;

@property (weak, nonatomic) IBOutlet CBBeaconsMap *beaconView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IXAudioManager *audioManager;
@property (nonatomic, strong) IXManager *manager;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) IXData *dataManager;

@property (nonatomic, strong) IXPositioningManager *posManager;

@end

@implementation IXDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[IXManager alloc] initWithDelegate:self];

    self.audioManager = APPDelegate.audioManager;
	// Do any additional setup after loading the view, typically from a nib.
    self.playing = NO;
    self.dataManager = [IXData sharedData];
    
    self.beaconView.physicalSize = CGSizeMake(10.0, 10.0);    // in meters, how do we set this initially?
    [self setupBeaconScanner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender
{
//    IXBeacon *ixBeacon = [[IXBeacon alloc] init];
//    [self.manager ixLocationManager:nil spottedIXBeacon:ixBeacon];
    if (self.playing) {
        [self.audioManager fadeOutBackgroundAudio];
        [self ixManager:self.manager stateChange:@"already playing"];
        self.playing = NO;          // should set this upon finishing the audio, but hey: it's a hack!
    } else {
        [self.audioManager prepareBackgroundPlayerWithFile:@"filmmuseum human"];
        [self.audioManager playBackgroundAudio];
        self.playing = YES;
        [self ixManager:self.manager stateChange:@"playing"];
    }
    
}

- (void) ixManager: (IXManager *)ixManager stateChange: (NSString *)newState
{
    self.infoLabel.alpha = 1.0;
    self.infoLabel.text = newState;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.infoLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.infoLabel.text = @"";
            self.infoLabel.alpha = 1.0;
        }];
    });
}


- (IBAction)speak:(id)sender
{
    if (self.playing) {
        [self.audioManager fadeOutBackgroundAudio];
        self.playing = NO;
        [self ixManager:self.manager stateChange:@"already speaking"];
    } else {
        [self.audioManager speak:@"Skatedoctor by Debra Barraud. Every now and then I have a patient asking me: ’Are you sure you know what you’re doing? Don’t you need to wait until the doctor is here? Then I have to explain them that I am the doctor."];
        self.playing = YES;
        [self ixManager:self.manager stateChange:@"speaking"];
    }
}


- (IBAction)stop:(id)sender
{
    if (self.playing) {
        [self.audioManager fade];
        self.playing = NO;
        [self ixManager:self.manager stateChange:@"stopping"];
    }
}

#pragma mark - Beaconscanner
- (void) setupBeaconScanner
{
    
}
@end
