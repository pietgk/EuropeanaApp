//
//  IXAudioManager.h
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

@class IXAudioManager;
//@protocol IXAudioManagerDelegate;


@protocol IXAudioManagerDelegate <NSObject>

@optional
/*
 callback which tells the delegate the progress in words of total sentence length, to update the progress slider
 */
- (void) audioManager:(IXAudioManager *)audioManager speakingRange:(NSRange)range totalLength:(NSUInteger)length;

/*
 callback which tells the delegate the progress of the audio from 0 - 1 (either audio or speech)
 */
- (void) audioManager:(IXAudioManager *)audioManager progress:(float)progress;

/* 
 callback which tells the delegate how long the audio is going to take, to label the progress slider 
 */
- (void) audioManager:(IXAudioManager *)audioManager totalDuration:(NSTimeInterval)duration;
@end

// #import "ArtWhisper-Bridging-Header.h"           // this is / was necessary to get swift to accept the IXAudioManagerDelegate ??? (seems Xcode bug)


//#import <Foundation/Foundation.h>

@interface IXAudioManager : NSObject
@property (nonatomic, weak) id <IXAudioManagerDelegate> delegate;
@property (nonatomic, readonly) NSTimeInterval duration;

- (instancetype)init NS_UNAVAILABLE;
+ (IXAudioManager*)sharedAudio;
- (void)tryPlayMusic;
- (void)playSystemSound;
- (void)prepareBackgroundPlayerWithFile:(NSString *)audioFile;
- (void)fadeOutBackgroundAudio;

- (void) speak:(NSString *)text;
- (void) pause;
- (void) resume;
- (void) fade;

@end

