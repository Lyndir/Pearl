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
//  Config.h
//  iLibs
//
//  Created by Maarten Billemont on 25/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

#define cFirstRun           NSStringFromSelector(@selector(firstRun))
#define cDeviceToken        NSStringFromSelector(@selector(deviceToken))

#define cFontSize           NSStringFromSelector(@selector(fontSize))
#define cLargeFontSize      NSStringFromSelector(@selector(largeFontSize))
#define cSmallFontSize      NSStringFromSelector(@selector(smallFontSize))
#define cFixedFontName      NSStringFromSelector(@selector(fixedFontName))
#define cFontName           NSStringFromSelector(@selector(fontName))
#define cSymbolicFontName   NSStringFromSelector(@selector(symbolicFontName))

#define cShadeColor         NSStringFromSelector(@selector(shadeColor))
#define cTransitionDuration NSStringFromSelector(@selector(transitionDuration))

#define cSoundFx            NSStringFromSelector(@selector(soundFx))
#define cMusic              NSStringFromSelector(@selector(music))
#define cVoice              NSStringFromSelector(@selector(voice))
#define cVibration          NSStringFromSelector(@selector(vibration))
#define cVisualFx           NSStringFromSelector(@selector(visualFx))

#define cTracks             NSStringFromSelector(@selector(tracks))
#define cTrackNames         NSStringFromSelector(@selector(trackNames))
#define cCurrentTrack       NSStringFromSelector(@selector(currentTrack))

@interface Config : NSObject {

    NSUserDefaults                                      *_defaults;

    NSMutableDictionary                                 *_resetTriggers;

    NSUInteger                                          *_gameRandomSeeds;
}

@property (readonly, retain) NSUserDefaults             *defaults;
@property (readonly, retain) NSMutableDictionary        *resetTriggers;

@property (nonatomic, readwrite, retain) NSNumber       *firstRun;
@property (nonatomic, readwrite, retain) NSData         *deviceToken;

@property (nonatomic, readwrite, retain) NSNumber       *fontSize;
@property (nonatomic, readwrite, retain) NSNumber       *largeFontSize;
@property (nonatomic, readwrite, retain) NSNumber       *smallFontSize;
@property (nonatomic, readwrite, retain) NSString       *fontName;
@property (nonatomic, readwrite, retain) NSString       *fixedFontName;
@property (nonatomic, readwrite, retain) NSString       *symbolicFontName;

@property (nonatomic, readwrite, retain) NSNumber       *shadeColor;
@property (nonatomic, readwrite, retain) NSNumber       *transitionDuration;

@property (nonatomic, readwrite, retain) NSArray        *tracks;
@property (nonatomic, readwrite, retain) NSArray        *trackNames;
@property (nonatomic, readonly, retain) NSString        *firstTrack;
@property (nonatomic, readonly, retain) NSString        *randomTrack;
@property (nonatomic, readonly, retain) NSString        *nextTrack;
@property (nonatomic, readwrite, retain) NSString       *currentTrack;
@property (nonatomic, readonly, retain) NSString        *currentTrackName;
@property (nonatomic, readwrite, retain) NSString       *playingTrack;

@property (nonatomic, readwrite, retain) NSNumber       *soundFx;
@property (nonatomic, readwrite, retain) NSNumber       *music;
@property (nonatomic, readwrite, retain) NSNumber       *voice;
@property (nonatomic, readwrite, retain) NSNumber       *vibration;
@property (nonatomic, readwrite, retain) NSNumber       *visualFx;

-(NSDate *) today;

- (void)setGameRandomSeed:(NSUInteger)aSeed;

/**
 * Return a default game random.  This is a special type of random value which is unaffected by external calls to srandom() or random().
 * If you use the game random to keep two remote games in sync, don't use it for anything that's tightly time-dependant,
 * otherwise race conditions WILL desync your games.
 * Split time-dependant code up into linearly constant scopes and use gameRandom: for them.
 */
- (NSUInteger)gameRandom;

/**
 * Return a game random from within the given scope.
 */
- (NSUInteger)gameRandom:(NSUInteger)scope;

+(Config *)                                             get;

@end
