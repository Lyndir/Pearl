/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  AudioController.h
//  Pearl
//
//  Created by Maarten Billemont on 29/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface PearlAudioController : NSObject <AVAudioPlayerDelegate> {

    AVAudioPlayer                *_audioPlayer;
    NSString                     *_nextTrack;

    NSMutableDictionary          *_effects;
}

- (void)clickEffect;
- (void)playTrack:(NSString *)track;
- (void)startNextTrack;
- (void)playEffectNamed:(NSString *)bundleName;

+ (const SystemSoundID)loadEffectWithName:(NSString *)bundleRef;
+ (void)vibrate;
+ (void)playEffect:(SystemSoundID)soundFileObject;
+ (void)disposeEffect:(SystemSoundID)soundFileObject;

+ (PearlAudioController *)get;

@end
