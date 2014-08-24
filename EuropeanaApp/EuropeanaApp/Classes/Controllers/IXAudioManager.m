//
//  IXAudioManager.m
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import "IXAudioManager.h"

@import AVFoundation;

#define VOLUMEDECREMENTDURATION 2.0
#define INTERVAL 0.2

@interface IXAudioManager () <AVAudioPlayerDelegate> {
    double fading;
}

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;
@property (assign) SystemSoundID pewPewSound;
@property (nonatomic, strong) NSTimer *fadeTimer;

- (void) fadeDecrement:(NSTimer *)aTimer;

@end

@implementation IXAudioManager

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureAudioSession];
        [self configureAudioPlayer];
        [self configureSystemSound];
        fading = 0.1;
    }
    return self;
}

- (void)tryPlayMusic {
    // If background music or other music is already playing, nothing more to do here
    if (self.backgroundMusicPlaying || [self.audioSession isOtherAudioPlaying]) {
        return;
    }
    
    // Play background music if no other music is playing and we aren't playing already
    //Note: prepareToPlay preloads the music file and can help avoid latency. If you don't
    //call it, then it is called anyway implicitly as a result of [self.backgroundMusicPlayer play];
    //It can be worthwhile to call prepareToPlay as soon as possible so as to avoid needless
    //delay when playing a sound later on.
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    self.backgroundMusicPlaying = YES;
}

- (void)playSystemSound {
    AudioServicesPlaySystemSound(self.pewPewSound);
}

#pragma mark - Private

- (void) configureAudioSession {
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    // Set category of audio session
    // See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
    // Not absolutely required in this example, but good to get into the habit of doing
    // See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
    
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
        self.backgroundMusicPlaying = NO;
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

- (void)prepareBackgroundPlayerWithFile:(NSString *)audioFile
{
    // Create audio player with background music
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:audioFile ofType:@"caf"];
    NSLog(@"Will play audio file: %@",audioFile);
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    if (backgroundMusicURL) {
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
        self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
        self.backgroundMusicPlayer.numberOfLoops = -1;	// Negative number means loop forever
        self.backgroundMusicPlayer.volume = 1.0;
    }
}

- (void)playBackgroundAudio;
{
    if (self.backgroundMusicPlaying || !self.backgroundMusicPlayer) {
        return;
    }
    
    // Play background music if no other music is playing and we aren't playing already
    //Note: prepareToPlay preloads the music file and can help avoid latency. If you don't
    [self.backgroundMusicPlayer play];
    self.backgroundMusicPlaying = YES;
}

- (void)stopBackgroundAudio
{
    if (self.backgroundMusicPlaying) {
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlaying = NO;
    }
}

- (void)configureAudioPlayer
{
    // Create audio player with background music
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    self.backgroundMusicPlayer.numberOfLoops = -1;	// Negative number means loop forever
}

- (void)fadeOutBackgroundAudio
{
    if (self.backgroundMusicPlayer.volume <= 0.0) {
        return;
    } else {
        if (self.fadeTimer) {
            [self.fadeTimer invalidate];
            self.fadeTimer = nil;
        }
        fading = self.backgroundMusicPlayer.volume / (VOLUMEDECREMENTDURATION / INTERVAL);
        self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:INTERVAL target:self selector:@selector(fadeDecrement:) userInfo:nil repeats:YES];
    }
    
}

- (void) fadeDecrement:(NSTimer *)aTimer
{
    if (!self.backgroundMusicPlayer) {
        [self.fadeTimer invalidate];
        self.fadeTimer = nil;
    } else {
        double volume = self.backgroundMusicPlayer.volume;
        // dirty hack!
        volume -= fading;
        if (volume <= 0.0) {
            volume = 0.0;
        }
        self.backgroundMusicPlayer.volume = volume;
        if (0.0 == volume) {
            [self.fadeTimer invalidate];
            self.fadeTimer = nil;
            [self.backgroundMusicPlayer stop];
            self.backgroundMusicPlayer = nil;
            self.backgroundMusicPlaying = NO;
            NSLog(@"finished fading out audio");
        }
    }
}

//-(void) fadeIn
//{
//    if (self.currentPlayer.volume >= 1.0f) return;
//    else {
//        self.currentPlayer.volume+=0.10;
//        __weak typeof (self) weakSelf = self;
//        [NSThread sleepForTimeInterval:0.2f];
//        [self.fadingQueue addOperationWithBlock:^{
//            NSLog(@"fading in %.2f", self.currentPlayer.volume);
//            [weakSelf fadeIn];
//        }];
//    }
//}
//-(void) fadeOut
//{
//    if (self.currentPlayer.volume <= 0.0f) return;
//    else {
//        self.currentPlayer.volume -=0.1;
//        __weak typeof (self) weakSelf = self;
//        [NSThread sleepForTimeInterval:0.2f];
//        [self.fadingQueue addOperationWithBlock:^{
//            NSLog(@"fading out %.2f", self.currentPlayer.volume);
//            [weakSelf fadeOut];
//        }];
//    }
//}

- (void)configureSystemSound {
    // This is the simplest way to play a sound.
    // But note with System Sound services you can only use:
    // File Formats (a.k.a. audio containers or extensions): CAF, AIF, WAV
    // Data Formats (a.k.a. audio encoding): linear PCM (such as LEI16) or IMA4
    // Sounds must be 30 sec or less
    // And only one sound plays at a time!
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"pew-pew-lei" ofType:@"caf"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_pewPewSound);
}

#pragma mark - AVAudioPlayerDelegate methods

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    //It is often not necessary to implement this method since by the time
    //this method is called, the sound has already stopped. You don't need to
    //stop it yourself.
    //In this case the backgroundMusicPlaying flag could be used in any
    //other portion of the code that needs to know if your music is playing.
    
    self.backgroundMusicInterrupted = YES;
    self.backgroundMusicPlaying = NO;
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player withOptions:(NSUInteger) flags{
    //Since this method is only called if music was previously interrupted
    //you know that the music has stopped playing and can now be resumed.
    [self tryPlayMusic];
    self.backgroundMusicInterrupted = NO;
}

@end
