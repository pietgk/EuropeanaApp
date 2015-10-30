//
//  IXViewController.m
//  EuropeanaApp
//
//  Created by Axel Roest on 23-08-14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXViewController.h"
#import "IXAppDelegate.h"
#import "IXAudioManager.h"
#import "IXData.h"


@interface IXViewController ()
- (IBAction)test:(id)sender;
- (IBAction)speak:(id)sender;
- (IBAction)stop:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IXAudioManager *audioManager;
@property (nonatomic, strong) IXManager *manager;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) IXData *dataManager;
@end

@implementation IXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [[IXManager alloc] initWithDelegate:self];

    self.audioManager = APPDelegate.audioManager;
	// Do any additional setup after loading the view, typically from a nib.
    self.playing = NO;
    self.dataManager = [[IXData alloc] init];
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
    self.infoLabel.text = newState;
}


- (IBAction)speak:(id)sender
{
    if (self.playing) {
        [self.audioManager fadeOutBackgroundAudio];
        self.playing = NO;
    } else {
        [self.audioManager prepareBackgroundPlayerWithFile:@"filmmuseum"];
        [self.audioManager playBackgroundAudio];
        self.playing = YES;
    }
}


- (IBAction)stop:(id)sender
{
    if (self.playing) {
        [self.audioManager fadeOutBackgroundAudio];
        self.playing = NO;
    }
}
@end
