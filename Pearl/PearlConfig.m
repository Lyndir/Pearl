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
//  PearlConfig.m
//  Pearl
//
//  Created by Maarten Billemont on 25/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlConfig.h"
#import "PearlLogger.h"
#import "PearlResettable.h"
#import "NSString_PearlSEL.h"
#import "PearlStringUtils.h"
#import "PearlStrings.h"
#ifdef PEARL_MEDIA
#import "PearlAudioController.h"
#endif
#ifdef PEARL_UIKIT
#import "PearlAppDelegate.h"
#endif
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif


@interface PearlConfig ()

@property (nonatomic, readwrite, retain) NSUserDefaults         *defaults;

@property (nonatomic, readwrite, retain) NSMutableDictionary    *resetTriggers;

@end


@implementation PearlConfig

@synthesize defaults = _defaults;
@synthesize delegate = _delegate, resetTriggers = _resetTriggers;
@synthesize notificationsChecked = _notificationsChecked, notificationsSupported = _notificationsSupported;

@dynamic build, version, copyright, firstRun, supportedNotifications, deviceToken;
@dynamic fontSize, largeFontSize, smallFontSize, fontName, fixedFontName, symbolicFontName;
@dynamic shadeColor, transitionDuration;
@dynamic soundFx, voice, vibration;
@dynamic tracks, trackNames, currentTrack, playingTrack;

#pragma mark Internal

- (id)init {

    if(!(self = [super init]))
        return nil;

    _gameRandomSeeds = 0;
    _gameRandomCounters = 0;
    [self setGameRandomSeed:arc4random()];

    self.defaults = [NSUserDefaults standardUserDefaults];
    [self.defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"",                                                           NSStringFromSelector(@selector(build)),
                                     @"",                                                           NSStringFromSelector(@selector(version)),
                                     @"",                                                           NSStringFromSelector(@selector(copyright)),
                                     [NSNumber numberWithBool:YES],                                 NSStringFromSelector(@selector(firstRun)),

                                     [NSNumber numberWithInt:
                                      [[PearlStrings get].fontSizeNormal intValue]],                NSStringFromSelector(@selector(fontSize)),
                                     [NSNumber numberWithInt:
                                      [[PearlStrings get].fontSizeLarge intValue]],                 NSStringFromSelector(@selector(largeFontSize)),
                                     [NSNumber numberWithInt:
                                      [[PearlStrings get].fontSizeSmall intValue]],                 NSStringFromSelector(@selector(smallFontSize)),
                                     [PearlStrings get].fontFamilyDefault,                          NSStringFromSelector(@selector(fontName)),
                                     [PearlStrings get].fontFamilyFixed,                            NSStringFromSelector(@selector(fixedFontName)),
                                     [PearlStrings get].fontFamilySymbolic,                         NSStringFromSelector(@selector(symbolicFontName)),

                                     [NSNumber numberWithLong:       0x332222cc],                   NSStringFromSelector(@selector(shadeColor)),
                                     [NSNumber numberWithFloat:      0.4f],                         NSStringFromSelector(@selector(transitionDuration)),

                                     [NSNumber numberWithBool:       YES],                          NSStringFromSelector(@selector(soundFx)),
                                     [NSNumber numberWithBool:       NO],                           NSStringFromSelector(@selector(voice)),
                                     [NSNumber numberWithBool:       YES],                          NSStringFromSelector(@selector(vibration)),

                                     [NSArray arrayWithObjects:
                                      @"sequential",
                                      @"random",
                                      @"",
                                      nil],                                                         NSStringFromSelector(@selector(tracks)),
                                     [NSArray arrayWithObjects:
                                      [PearlStrings get].songSequential,
                                      [PearlStrings get].songRandom,
                                      [PearlStrings get].songOff,
                                      nil],                                                         NSStringFromSelector(@selector(trackNames)),
                                     @"sequential",                                                 NSStringFromSelector(@selector(currentTrack)),

                                     nil]];

    self.resetTriggers = [NSMutableDictionary dictionary];
    
#ifdef PEARL_UIKIT
    self.delegate = [PearlAppDelegate get];
#endif

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    self.build = [info objectForKey:@"CFBundleVersion"];
    self.version = [info objectForKey:@"CFBundleShortVersionString"];
    self.copyright = [info objectForKey:@"NSHumanReadableCopyright"];

#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil
#else
    [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:nil queue:nil
#endif
                                                  usingBlock:^(NSNotification *note) {
                                                      self.firstRun = [NSNumber numberWithBool:NO];
                                                      [self.defaults synchronize];
                                                  }];

    return self;
}


+ (PearlConfig *)get {

    static PearlConfig *instance = nil;
    if(!instance)
        instance = [self new];

    if (![instance isKindOfClass:self])
        err(@"Tried to use config of type: %@, but the config instance is of the incompatible type: %@.  "
            @"You should probably add [%@ get] to your application delegate's +initialize.",
        self, [instance class], self);

    return instance;
}

+ (void)flush {

    [[self get].defaults synchronize];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    if ([NSStringFromSelector(aSelector) isSetter])
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];

    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {

    NSString *selector = NSStringFromSelector(anInvocation.selector);
    BOOL isSetter = [selector isSetter];
    selector = [selector setterToGetter];

    id currentValue = [self.defaults valueForKey:selector];
    if ([currentValue isKindOfClass:[NSData class]]) {
        trc(@"Unarchiving %@.%@", [self class], selector);
        currentValue = [NSKeyedUnarchiver unarchiveObjectWithData:currentValue];
    }

    if (isSetter) {
        __unsafe_unretained id newValue = nil;
        [anInvocation getArgument:&newValue atIndex:2];
        if (newValue == [NSNull null])
            newValue = nil;
        dbg(@"%@.%@ = [%@ ->] %@", [self class], selector, currentValue, newValue);

        if (newValue && ![newValue isKindOfClass:[NSString class]] && ![newValue isKindOfClass:[NSNumber class]] && ![newValue isKindOfClass:[NSDate class]] && ![newValue isKindOfClass:[NSArray class]] && ![newValue isKindOfClass:[NSDictionary class]]) {
            // TODO: This doesn't yet check arrays and dictionaries recursively to see if they need coding.
            if ([newValue conformsToProtocol:@protocol(NSCoding)]) {
                trc(@"Archiving %@.%@", [self class], selector);
                newValue = [NSKeyedArchiver archivedDataWithRootObject:newValue];
            } else
                err(@"Cannot update %@: Value type is not supported by plists and is not codable: %@", selector, newValue);
        }
        [self.defaults setValue:newValue forKey:selector];
        [self.delegate didUpdateConfigForKey:NSSelectorFromString(selector) fromValue:currentValue];
        
#ifdef PEARL_UIKIT
        NSString *resetTriggerKey = [self.resetTriggers objectForKey:selector];
        if (resetTriggerKey)
            [(id<PearlResettable>) [[PearlAppDelegate get] valueForKeyPath:resetTriggerKey] reset];
#endif
    }

    else {
        trc(@"%@.%@ = %@", [self class], selector, currentValue);
        __unsafe_unretained id returnValue = currentValue;
        [anInvocation setReturnValue:&returnValue];
    }
}


#pragma mark Audio

- (NSString *)firstTrack {

    if ([self.tracks count] <= 3)
        return @"";

    return [self.tracks objectAtIndex:0];
}

- (NSString *)randomTrack {

    if ([self.tracks count] <= 3)
        return @"";

    NSUInteger realTracks = ([self.tracks count] - 3);
    return [self.tracks objectAtIndex:arc4random() % realTracks];
}

- (NSString *)nextTrack {

    if ([self.tracks count] <= 3)
        return @"";

    id playingTrack = self.playingTrack;
    if(!playingTrack)
        playingTrack = @"";

    NSUInteger currentTrackIndex = [[self tracks] indexOfObject:playingTrack];
    if (currentTrackIndex == NSNotFound)
        currentTrackIndex = -1U;

    NSUInteger realTracks = [self.tracks count] - 3;
    return [self.tracks objectAtIndex:MIN(currentTrackIndex + 1, realTracks) % realTracks];
}

- (NSNumber *)music {

    return [NSNumber numberWithBool:[self.currentTrack length] > 0];
}

- (void)setMusic:(NSNumber *)aMusic {

#ifdef PEARL_MEDIA
    if ([aMusic boolValue] && ![self.music boolValue])
        [[PearlAudioController get] playTrack:@"random"];
    if (![aMusic boolValue] && [self.music boolValue])
        [[PearlAudioController get] playTrack:nil];
#endif
}

- (void)setCurrentTrack: (NSString *)currentTrack {

    if(currentTrack == nil)
        currentTrack = @"";

#ifdef PEARL_UIKIT
    NSString *oldTrack = [self.defaults objectForKey:NSStringFromSelector(@selector(currentTrack))];
#endif

    [self.defaults setObject:currentTrack forKey:NSStringFromSelector(@selector(currentTrack))];

#ifdef PEARL_UIKIT
    [[PearlAppDelegate get] didUpdateConfigForKey:@selector(currentTrack) fromValue:oldTrack];
#endif
}

-(NSString *) currentTrackName {

    id currentTrack = self.currentTrack;
    if(!currentTrack)
        currentTrack = @"";

    NSUInteger currentTrackIndex = [[self tracks] indexOfObject:currentTrack];
    return [[self trackNames] objectAtIndex:currentTrackIndex];
}

-(NSString *) playingTrackName {

    id playingTrack = self.playingTrack;
    if(!playingTrack)
        playingTrack = @"";

    NSUInteger playingTrackIndex = [[self tracks] indexOfObject:playingTrack];
    if (playingTrackIndex == NSNotFound || ![[[self tracks] objectAtIndex:playingTrackIndex] length])
        return nil;

    return [[self trackNames] objectAtIndex:playingTrackIndex];
}


#pragma mark Game Configuration

- (void)setGameRandomSeed:(unsigned)aSeed {

    @synchronized(self) {
        srandom(aSeed);
        free(_gameRandomSeeds);
        free(_gameRandomCounters);
        _gameRandomSeeds            = malloc(sizeof(NSUInteger) * PearlMaxGameRandom);
        _gameRandomCounters         = malloc(sizeof(NSUInteger) * PearlMaxGameRandom);
        for (NSUInteger s = 0; s < PearlMaxGameRandom; ++s){
            _gameRandomSeeds[s]     = (unsigned)random();
            _gameRandomCounters[s]  = 0;
        }
    }
}

- (long)gameRandom {

    return [self gameRandom:PearlMaxGameRandom - 1];
}

- (long)gameRandom:(NSUInteger)scope {

    NSAssert2(scope < PearlMaxGameRandom, @"Scope (%d) must be < %d", scope, PearlMaxGameRandom);

    @synchronized(self) {
        srandom(_gameRandomSeeds[scope]++);
        return random();
    }
}

- (long)gameRandom:(NSUInteger)scope from:(char*)file :(NSUInteger)line {

    long gr = [self gameRandom:scope];
//    if (scope == cMaxGameScope - 1 && _gameRandomSeeds[scope] % 5 == 0)
//        [[Logger get] dbg:@"%30s:%-5d\t" @"gameRandom(scope=%d, #%d)=%d", file, line, scope, ++_gameRandomCounters[scope], gr];

    return gr;
}


- (NSDate *)today {

    long now = (long) [[NSDate date] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:(now / (3600 * 24)) * (3600 * 24)];
}

- (NSNumber *)fontSize {

    return [NSNumber numberWithUnsignedInteger:(NSUInteger)([[self.defaults objectForKey:NSStringFromSelector(@selector(fontSize))] unsignedIntegerValue] * [PearlDeviceUtils uiScale])];
}

- (NSNumber *)largeFontSize {

    return [NSNumber numberWithUnsignedInteger:(NSUInteger)([[self.defaults objectForKey:NSStringFromSelector(@selector(largeFontSize))] unsignedIntegerValue] * [PearlDeviceUtils uiScale])];
}

- (NSNumber *)smallFontSize {

    return [NSNumber numberWithUnsignedInteger:(NSUInteger)([[self.defaults objectForKey:NSStringFromSelector(@selector(smallFontSize))] unsignedIntegerValue] * [PearlDeviceUtils uiScale])];
}

@end
