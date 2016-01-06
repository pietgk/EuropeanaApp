//
//  IXAudioManager.h
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IXAudioManager;
@protocol IXAudioManagerDelegate <NSObject>

@optional
- (void) audioManager:(IXAudioManager *)audioManager speakingRange:(NSRange)range totalLength:(NSUInteger) length;

@end

@interface IXAudioManager : NSObject
@property (nonatomic, weak) id <IXAudioManagerDelegate> delegate;
@property (nonatomic, readonly) NSTimeInterval duration;

- (instancetype)init NS_UNAVAILABLE;
+ (IXAudioManager*)sharedAudio;
- (void)tryPlayMusic;
- (void)playSystemSound;
- (void)prepareBackgroundPlayerWithFile:(NSString *)audioFile;
- (void)playBackgroundAudio;
- (void)fadeOutBackgroundAudio;

- (void) speak:(NSString *)text;
- (void) pause;
- (void) resume;
- (void) fade;

@end

