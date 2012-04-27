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
//  PearlConfig.h
//  Pearl
//
//  Created by Maarten Billemont on 25/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#define PearlMaxGameRandom          1024

#if DEBUG
#define PearlGameRandom()           [[PearlConfig get] gameRandom:PearlMaxGameRandom-1 from:basename(__FILE__) :__LINE__]
#else
#define PearlGameRandom()           [[PearlConfig get] gameRandom:PearlMaxGameRandom-1]
#endif

#if DEBUG
#define PearlGameRandomFor(scope)   [[PearlConfig get] gameRandom:scope from:basename(__FILE__) :__LINE__]
#else
#define PearlGameRandomFor(scope)   [[PearlConfig get] gameRandom:scope]
#endif

@interface PearlConfig : NSObject {

    NSUserDefaults                                          *_defaults;

    NSMutableDictionary                                     *_resetTriggers;

    NSUInteger                                              *_gameRandomSeeds;
    NSUInteger                                              *_gameRandomCounters;
    
    BOOL                                                    _notificationsChecked;
    BOOL                                                    _notificationsSupported;
}

@property (nonatomic, readonly, retain) NSUserDefaults      *defaults;
@property (nonatomic, readonly, retain) NSMutableDictionary *resetTriggers;

@property (nonatomic, readwrite, retain) NSString           *build;
@property (nonatomic, readwrite, retain) NSString           *version;
@property (nonatomic, readwrite, retain) NSString           *copyright;
@property (nonatomic, readwrite, retain) NSNumber           *firstRun;
@property (nonatomic, readwrite, retain) NSNumber           *supportedNotifications;
@property (nonatomic, readwrite, assign) BOOL               notificationsChecked;
@property (nonatomic, readwrite, assign) BOOL               notificationsSupported;
@property (nonatomic, readwrite, retain) NSData             *deviceToken;

@property (nonatomic, readwrite, retain) NSNumber           *fontSize;
@property (nonatomic, readwrite, retain) NSNumber           *largeFontSize;
@property (nonatomic, readwrite, retain) NSNumber           *smallFontSize;
@property (nonatomic, readwrite, retain) NSString           *fontName;
@property (nonatomic, readwrite, retain) NSString           *fixedFontName;
@property (nonatomic, readwrite, retain) NSString           *symbolicFontName;

@property (nonatomic, readwrite, retain) NSNumber           *shadeColor;
@property (nonatomic, readwrite, retain) NSNumber           *transitionDuration;

@property (nonatomic, readwrite, retain) NSArray            *tracks;
@property (nonatomic, readwrite, retain) NSArray            *trackNames;
@property (nonatomic, readonly, retain) NSString            *firstTrack;
@property (nonatomic, readonly, retain) NSString            *randomTrack;
@property (nonatomic, readonly, retain) NSString            *nextTrack;
@property (nonatomic, readwrite, retain) NSString           *currentTrack;
@property (nonatomic, readonly, retain) NSString            *currentTrackName;
@property (nonatomic, readwrite, retain) NSString           *playingTrack;

@property (nonatomic, readwrite, retain) NSNumber           *soundFx;
@property (nonatomic, readwrite, retain) NSNumber           *music;
@property (nonatomic, readwrite, retain) NSNumber           *voice;
@property (nonatomic, readwrite, retain) NSNumber           *vibration;

- (NSDate *)today;

- (void)setGameRandomSeed:(NSUInteger)aSeed;

/**
 * Return a default game random.  This is a special type of random value which is unaffected by external calls to srandom() or random().
 * If you use the game random to keep two remote games in sync, don't use it for anything that's tightly time-dependant,
 * otherwise race conditions WILL desync your games.
 * Split time-dependant code up into linearly constant scopes and use gameRandom: for them.
 */
- (long)gameRandom;

/**
 * Return a game random from within the given scope.
 */
- (long)gameRandom:(NSUInteger)scope;
- (long)gameRandom:(NSUInteger)scope from:(char*)file :(NSUInteger)line;

+ (PearlConfig *)                                           get;
+ (void)                                                    flush;

@end
