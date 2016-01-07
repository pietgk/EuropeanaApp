//
//  IXAudioManager.m
//  EuropeanaApp
//
//  Created by Fabio Milano on 8/23/14.
//  Copyright (c) 2014 Phluxus. All rights reserved.
//

/* We should probably split up the audiomanager and speech synthesizer part, but if it stays small, it can stay here */
/* might be helpful later:
 http://stackoverflow.com/questions/20403331/avaudiosession-mixing-with-avspeechutterance
 */


#import "IXAudioManager.h"

@import AVFoundation;


const float kVolumeDecrementDuration=2.0;
const float kFadeInterval=0.2;
const float kUpdateInterval=0.1;

@interface IXAudioManager () <AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate> {
    double fading;

}

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) AVSpeechSynthesizer *speechSynth;
@property (strong, nonatomic) AVSpeechUtterance *currentUtterance;
@property (assign) NSUInteger speechTextLength;

@property (assign) BOOL backgroundMusicInterrupted;
@property (assign) SystemSoundID pewPewSound;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSTimer *fadeTimer;
@property (nonatomic, assign) NSTimeInterval duration;

- (void) fadeDecrement:(NSTimer *)aTimer;
@property (assign) AudioState audioState;

@end

@implementation IXAudioManager

#pragma mark - Public
+ (IXAudioManager*)sharedAudio;
{
    static IXAudioManager *myAudio = nil;
    static dispatch_once_t onceAudioToken;
    dispatch_once(&onceAudioToken, ^{
        myAudio = [[self alloc] initPrivate];
    });
    return myAudio;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        [self configureAudioSession];
        [self configureAudioPlayer];
        [self configureSystemSound];
        fading = 0.1;
        self.audioState = silent;
        [self debugDeviceSpecs];
    }
    return self;
}

- (void) debugDeviceSpecs
{
//    NSArray *voices = [AVSpeechSynthesisVoice speechVoices];
//    NSLog(@"voices: %@",voices);

    NSLog(@"Speech rates between min:%f < (%f) < %f", AVSpeechUtteranceMinimumSpeechRate, AVSpeechUtteranceDefaultSpeechRate, AVSpeechUtteranceMaximumSpeechRate);
}

#pragma mark - OLD
- (void)tryPlayMusic {
    // If background music or other music is already playing, nothing more to do here
    if (audioPlaying == self.audioState || [self.audioSession isOtherAudioPlaying]) {
        return;
    }
    
    // Play background music if no other music is playing and we aren't playing already
    //Note: prepareToPlay preloads the music file and can help avoid latency. If you don't
    //call it, then it is called anyway implicitly as a result of [self.backgroundMusicPlayer play];
    //It can be worthwhile to call prepareToPlay as soon as possible so as to avoid needless
    //delay when playing a sound later on.
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    [self startUpdateTimer];
    self.audioState = audioPlaying;

    // update delegate duration
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:totalDuration:)]) {
        [self.delegate audioManager:self totalDuration:self.backgroundMusicPlayer.duration];
    }

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
        self.audioState = silent;
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
//    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:audioFile ofType:@"caf"];
    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:audioFile ofType:nil];
    NSLog(@"Will play audio file: %@",audioFile);
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    if (backgroundMusicURL) {
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
        self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
        self.backgroundMusicPlayer.numberOfLoops = -1;	// Negative number means loop forever
        self.backgroundMusicPlayer.volume = 1.0;
        self.duration = self.backgroundMusicPlayer.duration;
    }
}

// obsolete
- (void)playBackgroundAudio;
{
    if (audioPlaying == self.audioState || !self.backgroundMusicPlayer) {
        return;
    }
    
    // Play background music if no other music is playing and we aren't playing already
    //Note: prepareToPlay preloads the music file and can help avoid latency. If you don't
    [self.backgroundMusicPlayer play];
    self.audioState = audioPlaying;
    [self startUpdateTimer];
}

- (void)stopBackgroundAudio
{
    if (audioPlaying == self.audioState) {
        [self.backgroundMusicPlayer stop];
        self.audioState = silent;
        [self stopUpdateTimer];
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

#pragma mark - Timers
- (void)startUpdateTimer
{
    [self stopUpdateTimer];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateInterval target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}

- (void)stopUpdateTimer
{
    if (self.updateTimer) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}

// update progress bar in delegate
- (void) updateTimer:(NSTimer *)aTimer
{
    // calculation depends on speech vs audio
    float progress = (float)(self.backgroundMusicPlayer.currentTime / self.backgroundMusicPlayer.duration);
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:progress:)]) {
        [self.delegate audioManager:self progress:progress];
    }
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
        fading = self.backgroundMusicPlayer.volume / (kVolumeDecrementDuration / kFadeInterval);
        self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:kFadeInterval target:self selector:@selector(fadeDecrement:) userInfo:nil repeats:YES];
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
            [self stopBackgroundAudio];
            self.backgroundMusicPlayer = nil;
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

#pragma mark - Beeps

- (void)playSystemSound {
    AudioServicesPlaySystemSound(self.pewPewSound);
}

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
    //In this case the audioState state could be used in any
    //other portion of the code that needs to know if your music is playing.
    
    self.backgroundMusicInterrupted = YES;
    self.audioState = silent;
    [self stopUpdateTimer];
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player withOptions:(NSUInteger) flags{
    //Since this method is only called if music was previously interrupted
    //you know that the music has stopped playing and can now be resumed.
    [self tryPlayMusic];
    self.backgroundMusicInterrupted = NO;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audioState = silent;
    [self stopUpdateTimer];
}

- (void) audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSString *source = (player.url != nil) ? player.url.relativePath : @"unknown";
    NSLog(@"Audio decode error: %@ in file: %@", error, source);
}

#pragma mark -
// agnostic pause and continue methods
- (void) pause
{
    switch (self.audioState) {
        case audioPlaying:
            [self.backgroundMusicPlayer pause];
            self.audioState = audioPaused;
            break;
        case speechPlaying:
            [self.speechSynth pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
            self.audioState = speechPaused;
            break;
        default:
            break;
    }
    [self stopUpdateTimer];
}

- (void) stop
{
    switch (self.audioState) {
        case audioPlaying:
            [self.backgroundMusicPlayer stop];
            self.audioState = silent;
            break;
        case speechPlaying:
            [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryWord];
            self.audioState = silent;
            break;
        default:
            break;
    }
    [self stopUpdateTimer];
}


- (void) resume
{
    switch (self.audioState) {
        case audioPaused:
            [self.backgroundMusicPlayer play];
            self.audioState = audioPlaying;
            break;
        case speechPaused:
            [self.speechSynth continueSpeaking];
            self.audioState = speechPlaying;
            break;
        default:
            break;
    }
    [self startUpdateTimer];
}

- (void) fade
{
    switch (self.audioState) {
        case audioPlaying:
            [self fadeOutBackgroundAudio];
            break;
        case speechPlaying:
            [self fadeOutSpeech];
            break;
        default:
            break;
    }
}

#pragma mark - speech synthesis
/* Current voices (iOS 9.1) 
 voices: (
 Language: ar-SA, Name: Maged, Quality: Default",
 Language: cs-CZ, Name: Zuzana, Quality: Default",
 Language: da-DK, Name: Sara, Quality: Default",
 Language: de-DE, Name: Anna, Quality: Default",
 Language: el-GR, Name: Melina, Quality: Default",
 Language: en-AU, Name: Karen, Quality: Default",
 Language: en-GB, Name: Daniel, Quality: Default",
 Language: en-IE, Name: Moira, Quality: Default",
 Language: en-US, Name: Samantha, Quality: Default",
 Language: en-ZA, Name: Tessa, Quality: Default",
 Language: es-ES, Name: Monica, Quality: Default",
 Language: es-MX, Name: Paulina, Quality: Default",
 Language: fi-FI, Name: Satu, Quality: Default",
 Language: fr-CA, Name: Amelie, Quality: Default",
 Language: fr-FR, Name: Thomas, Quality: Default",
 Language: he-IL, Name: Carmit, Quality: Default",
 Language: hi-IN, Name: Lekha, Quality: Default",
 Language: hu-HU, Name: Mariska, Quality: Default",
 Language: id-ID, Name: Damayanti, Quality: Default",
 Language: it-IT, Name: Alice, Quality: Default",
 Language: ja-JP, Name: Kyoko, Quality: Default",
 Language: ko-KR, Name: Yuna, Quality: Default",
 Language: nl-BE, Name: Ellen, Quality: Default",
 Language: nl-NL, Name: Xander, Quality: Default",
 Language: no-NO, Name: Nora, Quality: Default",
 Language: pl-PL, Name: Zosia, Quality: Default",
 Language: pt-BR, Name: Luciana, Quality: Default",
 Language: pt-PT, Name: Joana, Quality: Default",
 Language: ro-RO, Name: Ioana, Quality: Default",
 Language: ru-RU, Name: Milena, Quality: Default",
 Language: sk-SK, Name: Laura, Quality: Default",
 Language: sv-SE, Name: Alva, Quality: Default",
 Language: th-TH, Name: Kanya, Quality: Default",
 Language: tr-TR, Name: Yelda, Quality: Default",
 Language: zh-CN, Name: Ting-Ting, Quality: Default",
 Language: zh-HK, Name: Sin-Ji, Quality: Default",
 Language: zh-TW, Name: Mei-Jia, Quality: Default"
 )
*/

- (AVSpeechSynthesizer* ) speechSynth
{
    if (!_speechSynth) {
        _speechSynth = [[AVSpeechSynthesizer alloc] init];
        [_speechSynth pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
        _speechSynth.delegate = self;
    }
    return _speechSynth;
}

- (AVSpeechSynthesisVoice *) defaultVoice
{
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-IE"];
//    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithIdentifier:@"Daniel"];
    return voice;
}

- (void) speak:(NSString *)text
{
    if (silent == self.audioState) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
        utterance.voice = [self defaultVoice];
        utterance.volume = 1.0;
        utterance.rate = 0.4;
        [self.speechSynth speakUtterance:utterance];
        self.currentUtterance = utterance;
        self.speechTextLength = text.length;
        self.audioState = speechPlaying;
    }
}

- (void)fadeOutSpeech
{
    if (self.currentUtterance.volume <= 0.0) {
        return;
    } else {
        if (self.fadeTimer) {
            [self.fadeTimer invalidate];
            self.fadeTimer = nil;
        }
        fading = 1.0 / (kVolumeDecrementDuration / kFadeInterval);
        self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:kFadeInterval target:self selector:@selector(fadeDecrementSpeech:) userInfo:nil repeats:YES];
    }
    
}

- (void) fadeDecrementSpeech:(NSTimer *)aTimer
{
    if (!self.speechSynth) {
        [self.fadeTimer invalidate];
        self.fadeTimer = nil;
    } else {
        double volume = self.currentUtterance.volume;
        // dirty hack!
        volume -= fading;
        if (volume <= 0.0) {
            volume = 0.0;
        }
        self.currentUtterance.volume = volume;
        if (0.0 == volume) {
            [self.fadeTimer invalidate];
            self.fadeTimer = nil;
            [self.speechSynth stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            self.audioState = silent;
            NSLog(@"finished fading out speech");
        }
    }
}


#pragma mark - AVSpeechSynthesizerDelegate methods
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(nonnull AVSpeechUtterance *)utterance
{
    self.audioState = speechPlaying;
}

- (void) speechSynthesizer:synthesizer didFinishSpeechUtterance:(nonnull AVSpeechUtterance *)utterance
{
    self.currentUtterance = nil;
    self.audioState = silent;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance
{
    self.audioState = speechPaused;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
#warning start using - (void) audioManager:(IXAudioManager *)audioManager progress:(float)progress totalLength:(float)totalLength;

    NSUInteger current = characterRange.location;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioManager:speakingRange:totalLength:)]) {
        [self.delegate audioManager:self speakingRange:characterRange totalLength:self.speechTextLength];
    }
    // call back delegate function to update stuff on screen.
}


@end
