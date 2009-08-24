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
//  Config.m
//  iLibs
//
//  Created by Maarten Billemont on 25/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#define dFontSize           NSStringFromSelector(@selector(fontSize))
#define dLargeFontSize      NSStringFromSelector(@selector(largeFontSize))
#define dSmallFontSize      NSStringFromSelector(@selector(smallFontSize))
#define dFixedFontName      NSStringFromSelector(@selector(fixedFontName))
#define dFontName           NSStringFromSelector(@selector(fontName))

#define dShadeColor         NSStringFromSelector(@selector(shadeColor))
#define dTransitionDuration NSStringFromSelector(@selector(transitionDuration))

#define dSoundFx            NSStringFromSelector(@selector(soundFx))
#define dVoice              NSStringFromSelector(@selector(voice))
#define dVibration          NSStringFromSelector(@selector(vibration))
#define dVisualFx           NSStringFromSelector(@selector(visualFx))

#define dTracks             NSStringFromSelector(@selector(tracks))
#define dTrackNames         NSStringFromSelector(@selector(trackNames))
#define dCurrentTrack       NSStringFromSelector(@selector(currentTrack))

#define dScore              NSStringFromSelector(@selector(score))
#define dTopScoreHistory    NSStringFromSelector(@selector(topScoreHistory))

#import "AbstractAppDelegate.h"
#import "Resettable.h"


@interface Config ()

@property (readwrite, retain) NSUserDefaults    *defaults;

@end


@implementation Config

@synthesize defaults;

@dynamic fontSize, largeFontSize, smallFontSize, fontName, fixedFontName;
@dynamic shadeColor, transitionDuration;
@dynamic soundFx, voice, vibration, visualFx;
@dynamic tracks, trackNames, currentTrack;
@dynamic score, topScoreHistory;

#pragma mark Internal

-(id) init {

    if(!(self = [super init]))
        return self;

    self.defaults = [NSUserDefaults standardUserDefaults];

    [self.defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:
                                      [NSLocalizedString(@"font.size.normal", @"34") intValue]], dFontSize,
                                     [NSNumber numberWithInt:
                                      [NSLocalizedString(@"font.size.large", @"48") intValue]],  dLargeFontSize,
                                     [NSNumber numberWithInt:
                                      [NSLocalizedString(@"font.size.small", @"18") intValue]],  dSmallFontSize,
                                     NSLocalizedString(@"font.family.default",
                                                       @"Marker Felt"),                          dFontName,
                                     NSLocalizedString(@"font.family.fixed",
                                                       @"American Typewriter"),                  dFixedFontName,
                                     
                                     [NSNumber numberWithLong:       0x332222cc],                dShadeColor,
                                     [NSNumber numberWithFloat:      0.5f],                      dTransitionDuration,
                                
                                     [NSNumber numberWithBool:       YES],                       dSoundFx,
                                     [NSNumber numberWithBool:       NO],                        dVoice,
                                     [NSNumber numberWithBool:       YES],                       dVibration,
                                     [NSNumber numberWithBool:       YES],                       dVisualFx,
                                
                                     [NSArray arrayWithObjects:
                                      @"random",
                                      @"",
                                      nil],                                                      dTracks,
                                     [NSArray arrayWithObjects:
                                      NSLocalizedString(@"config.song.random", @"Shuffle"),
                                      NSLocalizedString(@"config.song.off", @"Off"),
                                      nil],                                                      dTrackNames,
                                     @"random",                                                  dCurrentTrack,
                                
                                     [NSNumber numberWithInteger:    0],                         dScore,
                                     [NSDictionary dictionary],                                  dTopScoreHistory,

                                     nil]];
    
    updateTriggers  = [[NSArray alloc] initWithObjects:
                       dLargeFontSize,
                       dSmallFontSize,
                       dFontSize,
                       dFontName,
                       dFixedFontName,
                       dSoundFx,
                       dVoice,
                       dVibration,
                       dVisualFx,
                       dTracks,
                       dTrackNames,
                       dCurrentTrack,
                       nil
                       ];
    resetTriggers   = [[NSDictionary alloc] init];
    
    return self;
}


-(void) dealloc {
    
    self.defaults = nil;
    
    [super dealloc];
}


+(Config *) get {
    
    static Config *configInstance;
    if(!configInstance)
        configInstance = [[Config alloc] init];
    
    return configInstance;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    if ([NSStringFromSelector(aSelector) hasPrefix:@"set"])
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    if ([selector hasPrefix:@"set"]) {
        NSRange firstChar, rest;
        firstChar.location  = 3;
        firstChar.length    = 1;
        rest.location       = 4;
        rest.length         = selector.length - 5;
        
        selector = [NSString stringWithFormat:@"%@%@",
                    [[selector substringWithRange:firstChar] lowercaseString],
                    [selector substringWithRange:rest]];
        
        id value;
        [anInvocation getArgument:&value atIndex:2];
        
        [self.defaults setObject:value forKey:selector];
        
        if ([updateTriggers containsObject:selector])
            [[AbstractAppDelegate get] updateConfig];
        NSString *resetTriggerKey = [resetTriggers objectForKey:selector];
        if (resetTriggerKey)
            [(id<Resettable>) [[AbstractAppDelegate get] valueForKey:resetTriggerKey] reset];
    }
    
    else {
        id value = [self.defaults objectForKey:selector];
        [anInvocation setReturnValue:&value];
    }
}


#pragma mark Audio

-(NSString *) randomTrack {
    
    NSArray *tracks = self.tracks;
    
    if ([tracks count] <= 2)
        return @"";
    
    return [tracks objectAtIndex:random() % ([tracks count] - 2)];
}
-(void) setCurrentTrack: (NSString *)currentTrack {
    
    if(currentTrack == nil)
        currentTrack = @"";
    
    [[AbstractAppDelegate get] updateConfig];
}
-(NSString *) currentTrackName {
    
    id currentTrack = [self currentTrack];
    if(!currentTrack)
        currentTrack = @"";
    
    NSUInteger currentTrackIndex = [[self tracks] indexOfObject:currentTrack];
    return [[self trackNames] objectAtIndex:currentTrackIndex];
}


#pragma mark Game Configuration

-(NSDate *) today {
    
    long now = (long) [[NSDate date] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:(now / (3600 * 24)) * (3600 * 24)];
}


#pragma mark User Status

-(void) recordScore:(NSInteger)score {
    
    if(score < 0)
        score = 0;
    NSNumber *scoreObject = [NSNumber numberWithInteger:score];
    
    // Is this a new top score for today?
    NSDictionary *topScores = [self topScoreHistory];
    NSString *today = [[self today] description];
    NSNumber *topScoreToday = [topScores objectForKey:today];
    
    if(topScoreToday == nil || [topScoreToday integerValue] < score) {
        // Record top score.
        NSMutableDictionary *newTopScores = [topScores mutableCopy];
        [newTopScores setObject: scoreObject forKey:today];
        [self setTopScoreHistory:newTopScores];
        [newTopScores release];
    }
    
    self.score = scoreObject;
}


@end
