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

#import "AbstractAppDelegate.h"
#import "Resettable.h"
#import "NSString_SEL.h"


@interface Config ()

@property (readwrite, retain) NSUserDefaults                                       *defaults;

@property (readwrite, retain) NSDictionary                                         *resetTriggers;

@end


@implementation Config

@synthesize defaults = _defaults;
@synthesize resetTriggers = _resetTriggers;


@dynamic firstRun;
@dynamic fontSize, largeFontSize, smallFontSize, fontName, fixedFontName, symbolicFontName;
@dynamic shadeColor, transitionDuration;
@dynamic soundFx, voice, vibration, visualFx;
@dynamic tracks, trackNames, currentTrack;

#pragma mark Internal

-(id) init {

    if(!(self = [super init]))
        return self;

    self.defaults = [NSUserDefaults standardUserDefaults];

    [self.defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES],                                 cFirstRun,
                                     
                                     [NSNumber numberWithInt:
                                      [l(@"font.size.normal") intValue]],                           cFontSize,
                                     [NSNumber numberWithInt:
                                      [l(@"font.size.large") intValue]],                            cLargeFontSize,
                                     [NSNumber numberWithInt:
                                      [l(@"font.size.small") intValue]],                            cSmallFontSize,
                                     l(@"font.family.default"),                                     cFontName,
                                     l(@"font.family.fixed"),                                       cFixedFontName,
                                     l(@"font.family.symbolic"),                                    cSymbolicFontName,
                                     
                                     [NSNumber numberWithLong:       0x332222cc],                   cShadeColor,
                                     [NSNumber numberWithFloat:      0.5f],                         cTransitionDuration,
                                
                                     [NSNumber numberWithBool:       YES],                          cSoundFx,
                                     [NSNumber numberWithBool:       NO],                           cVoice,
                                     [NSNumber numberWithBool:       YES],                          cVibration,
                                     [NSNumber numberWithBool:       YES],                          cVisualFx,
                                
                                     [NSArray arrayWithObjects:
                                      @"random",
                                      @"",
                                      nil],                                                         cTracks,
                                     [NSArray arrayWithObjects:
                                      l(@"menu.config.song.random"),
                                      l(@"menu.config.song.off"),
                                      nil],                                                         cTrackNames,
                                     @"random",                                                     cCurrentTrack,

                                     nil]];
    
    self.resetTriggers = [NSDictionary dictionary];
    
    return self;
}


-(void) dealloc {
    
    self.defaults = nil;
    
    [super dealloc];
}


+(Config *) get {
    
    static Config *configInstance;
    if(!configInstance)
        configInstance = [self new];
    
    return configInstance;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
    if ([NSStringFromSelector(aSelector) hasPrefix:@"set"])
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    NSString *selector = NSStringFromSelector(anInvocation.selector);
    if ([selector isSetter]) {
        selector = [selector setterToGetter];
        
        id value;
        [anInvocation getArgument:&value atIndex:2];
        
        [self.defaults setObject:value forKey:selector];
        
        [[AbstractAppDelegate get] didUpdateConfigForKey:NSSelectorFromString(selector)];
        NSString *resetTriggerKey = [self.resetTriggers objectForKey:selector];
        if (resetTriggerKey)
            [(id<Resettable>) [[AbstractAppDelegate get] valueForKey:resetTriggerKey] reset];
    }
    
    else {
        id value = [self.defaults objectForKey:selector];
        [anInvocation setReturnValue:&value];
    }
}


#pragma mark Audio

- (NSString *)randomTrack {
    
    if ([self.tracks count] <= 2)
        return @"";
    
    return [self.tracks objectAtIndex:random() % ([self.tracks count] - 2)];
}
- (NSNumber *)music {

    return [NSNumber numberWithBool:[self.currentTrack length]];
}
- (void)setMusic:(NSNumber *)aMusic {
    
    if ([aMusic boolValue] && ![self.music boolValue])
        [[AudioController get] playTrack:@"random"];
    if (![aMusic boolValue] && [self.music boolValue])
        [[AudioController get] playTrack:nil];
}
- (void)setCurrentTrack: (NSString *)currentTrack {
    
    if(currentTrack == nil)
        currentTrack = @"";
    
    [self.defaults setObject:currentTrack forKey:cCurrentTrack];
    
    [[AbstractAppDelegate get] didUpdateConfigForKey:NSSelectorFromString(cCurrentTrack)];
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


@end
