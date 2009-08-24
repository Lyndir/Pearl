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
//  iLibs
//
//  Created by Maarten Billemont on 29/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "AudioController.h"

@implementation AudioController


-(void) clickEffect {
    
    static SystemSoundID clicky = 0;
    
    if([[Config get].soundFx boolValue]) {
        if(clicky == 0)
            clicky = [AudioController loadEffectWithName:@"snapclick.caf"];
        
        [AudioController playEffect:clicky];
    }
    
    else {
        [AudioController disposeEffect:clicky];
        clicky = 0;
    }
}


-(void) playTrack:(NSString *)track {
    
    if(![track length])
        track = nil;
    
    nextTrack = track;
    [self startNextTrack];
}


-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)success {
    
    if(player != audioPlayer)
        return;
    
    if(nextTrack == nil)
        [[Config get] setCurrentTrack:nil];
    
    [self startNextTrack];
}

-(void) startNextTrack {
    
    if([audioPlayer isPlaying]) {
        [audioPlayer stop];
        [self audioPlayerDidFinishPlaying:audioPlayer successfully:NO];
    } else if(nextTrack) {
        NSString *track = nextTrack;
        if([track isEqualToString:@"random"])
            track = [Config get].randomTrack;
        NSURL *nextUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:track ofType:nil]];
        
        if(audioPlayer != nil && ![audioPlayer.url isEqual:nextUrl]) {
            [audioPlayer release];
            audioPlayer = nil;
        }
        
        if(audioPlayer == nil)
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:nextUrl error:nil];
        
        [audioPlayer setDelegate:self];
        [audioPlayer play];
        
        [[Config get] setCurrentTrack:nextTrack];
    }
}


- (void)playEffectNamed:(NSString *)bundleName {
    
    SystemSoundID effect = [(NSNumber *) [effects objectForKey:bundleName] unsignedIntValue];
    if (effect == 0) {
        effect = [AudioController loadEffectWithName:[NSString stringWithFormat:@"%@.caf", bundleName]];
        if (effect == 0)
            return;
        
        [effects setObject:[NSNumber numberWithUnsignedInt:effect] forKey:bundleName];
    }
    
    [AudioController playEffect:effect];
}


-(void) dealloc {
    
    [audioPlayer release];
    audioPlayer = nil;
    
    [nextTrack release];
    nextTrack = nil;
    
    [super dealloc];
}


+(void) vibrate {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


+(void) playEffect:(SystemSoundID)soundFileObject {
    
    AudioServicesPlaySystemSound(soundFileObject);
}


+(SystemSoundID) loadEffectWithName:(NSString *)bundleRef {
    
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

+(AudioController *) get {
    
    static AudioController *sharedAudioController = nil;
    if(sharedAudioController == nil)
        sharedAudioController = [[AudioController alloc] init];
    
    return sharedAudioController;
}

@end
