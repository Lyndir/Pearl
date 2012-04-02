/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  AudioController.m
//  Pearl
//
//  Created by Maarten Billemont on 29/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlAudioController.h"
#import "PearlLogger.h"
#import "PearlConfig.h"

@interface PearlAudioController ()

@property (readwrite, retain) AVAudioPlayer                *audioPlayer;
@property (readwrite, copy) NSString                     *nextTrack;

@property (readwrite, retain) NSMutableDictionary          *effects;

@end


@implementation PearlAudioController

@synthesize audioPlayer = _audioPlayer;
@synthesize nextTrack = _nextTrack;
@synthesize effects = _effects;


-(void) clickEffect {
    
    static SystemSoundID instance = 0;
    
    if([[PearlConfig get].soundFx boolValue]) {
        if (!instance)
            instance = [PearlAudioController loadEffectWithName:@"snapclick.caf"];
        
        [PearlAudioController playEffect:instance];
    }
    
    else {
        [PearlAudioController disposeEffect:instance];
        instance = 0;
    }
}


-(void) playTrack:(NSString *)track {
    
    if(![track length])
        track = nil;
    
    self.nextTrack = track;
    [self startNextTrack];
}


-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)success {
    
    if(player != self.audioPlayer)
        return;
    
    if(self.nextTrack == nil)
        [[PearlConfig get] setCurrentTrack:nil];
    
    [self startNextTrack];
}

-(void) startNextTrack {
    
    if([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
        [self audioPlayerDidFinishPlaying:self.audioPlayer successfully:NO];
    } else if(self.nextTrack) {
        NSString *track = self.nextTrack;
        if([track isEqualToString:@"random"])
            track = [PearlConfig get].randomTrack;
        if([track isEqualToString:@"sequential"])
            track = [PearlConfig get].nextTrack;
        NSURL *nextUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:track ofType:nil]];
        
        if(self.audioPlayer != nil && ![self.audioPlayer.url isEqual:nextUrl]) {
            self.audioPlayer = nil;
        }
        
        if(self.audioPlayer == nil)
            self.audioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:nextUrl error:nil] autorelease];
        
        [self.audioPlayer setDelegate:self];
        [self.audioPlayer play];
        
        [[PearlConfig get] setPlayingTrack:track];
        [[PearlConfig get] setCurrentTrack:self.nextTrack];
    }
}


- (void)playEffectNamed:(NSString *)bundleName {
    
    SystemSoundID effect = [(NSNumber *) [self.effects objectForKey:bundleName] unsignedIntValue];
    if (effect == 0) {
        effect = [PearlAudioController loadEffectWithName:[NSString stringWithFormat:@"%@.caf", bundleName]];
        if (effect == 0)
            return;
        
        [self.effects setObject:[NSNumber numberWithUnsignedInt:effect] forKey:bundleName];
    }
    
    [PearlAudioController playEffect:effect];
}


-(void) dealloc {
    
    self.audioPlayer = nil;
    self.nextTrack = nil;
    self.effects = nil;

    [super dealloc];
}


+(void) vibrate {
    
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
#else
    err(@"Vibration not supported on this platform.");
#endif
}


+(void) playEffect:(SystemSoundID)soundFileObject {
    
    if([[PearlConfig get].soundFx boolValue])
        AudioServicesPlaySystemSound(soundFileObject);
}


+(const SystemSoundID) loadEffectWithName:(NSString *)bundleRef {
    
    // Get the URL to the sound file to play
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) bundleRef, NULL, NULL);
    
    // Create a system sound object representing the sound file
    SystemSoundID soundFileObject;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
    CFRelease(soundFileURLRef);
    
    return soundFileObject;
}


+(void) disposeEffect:(SystemSoundID)soundFileObject {
    
    AudioServicesDisposeSystemSoundID(soundFileObject);
}

+(PearlAudioController *) get {
    
    static PearlAudioController *instance = nil;
    if(!instance)
        instance = [self new];
    
    return instance;
}

@end
