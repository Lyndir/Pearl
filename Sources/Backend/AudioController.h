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
//  AudioController.h
//  iLibs
//
//  Created by Maarten Billemont on 29/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface AudioController : NSObject <AVAudioPlayerDelegate> {
    
    AVAudioPlayer               *audioPlayer;
    NSString                    *nextTrack;
    
    NSMutableDictionary         *effects;
}

-(void) clickEffect;
-(void) playTrack:(NSString *)track;
-(void) startNextTrack;
- (void)playEffectNamed:(NSString *)bundleName;

+(SystemSoundID) loadEffectWithName:(NSString *)bundleRef;
+(void) vibrate;
+(void) playEffect:(SystemSoundID)soundFileObject;
+(void) disposeEffect:(SystemSoundID)soundFileObject;

+(AudioController *) get;

@end
