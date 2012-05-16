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
//  PearlConfig.h
//  Pearl
//
//  Created by Maarten Billemont on 25/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#define PearlMaxGameRandom          1024

#ifdef DEBUG
#define PearlGameRandom()           [[PearlConfig get] gameRandom:PearlMaxGameRandom-1 from:basename(__FILE__) :__LINE__]
#else
#define PearlGameRandom()           [[PearlConfig get] gameRandom:PearlMaxGameRandom-1]
#endif

#ifdef DEBUG
#define PearlGameRandomFor(scope)   [[PearlConfig get] gameRandom:scope from:basename(__FILE__) :__LINE__]
#else
#define PearlGameRandomFor(scope)   [[PearlConfig get] gameRandom:scope]
#endif

@protocol PearlConfigDelegate <NSObject>

@optional
- (void)didUpdateConfigForKey:(SEL)configKey fromValue:(id)oldValue;

@end

@interface PearlConfig : NSObject {

    NSUserDefaults                                          *_defaults;

    id<PearlConfigDelegate>                                 delegate;
    NSMutableDictionary                                     *_resetTriggers;

    unsigned                                                *_gameRandomSeeds;
    NSUInteger                                              *_gameRandomCounters;
    
    BOOL                                                    _notificationsChecked;
    BOOL                                                    _notificationsSupported;
}

@property (nonatomic, readonly, retain) NSUserDefaults      *defaults;
@property (nonatomic, weak) id<PearlConfigDelegate>         delegate;
@property (nonatomic, readonly, retain) NSMutableDictionary *resetTriggers;

@property (nonatomic, readwrite, retain) NSString           *build;
@property (nonatomic, readwrite, retain) NSString           *version;
@property (nonatomic, readwrite, retain) NSString           *copyright;
@property (nonatomic, readwrite, retain) NSNumber           *firstRun;
@property (nonatomic, readwrite, retain) NSNumber           *launchCount;
@property (nonatomic, readwrite, retain) NSNumber           *askForReviews;
@property (nonatomic, readwrite, retain) NSNumber           *reviewAfterLaunches;
@property (nonatomic, readwrite, retain) NSString           *reviewedVersion;
@property (nonatomic, readwrite, retain) NSString           *iTunesID;
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

- (void)setGameRandomSeed:(unsigned)aSeed;

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
