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

#define cFontSize           NSStringFromSelector(@selector(fontSize))
#define cLargeFontSize      NSStringFromSelector(@selector(largeFontSize))
#define cSmallFontSize      NSStringFromSelector(@selector(smallFontSize))
#define cFixedFontName      NSStringFromSelector(@selector(fixedFontName))
#define cFontName           NSStringFromSelector(@selector(fontName))

#define cShadeColor         NSStringFromSelector(@selector(shadeColor))
#define cTransitionDuration NSStringFromSelector(@selector(transitionDuration))

#define cSoundFx            NSStringFromSelector(@selector(soundFx))
#define cVoice              NSStringFromSelector(@selector(voice))
#define cVibration          NSStringFromSelector(@selector(vibration))
#define cVisualFx           NSStringFromSelector(@selector(visualFx))

#define cTracks             NSStringFromSelector(@selector(tracks))
#define cTrackNames         NSStringFromSelector(@selector(trackNames))
#define cCurrentTrack       NSStringFromSelector(@selector(currentTrack))

#define cScore              NSStringFromSelector(@selector(score))
#define cTopScoreHistory    NSStringFromSelector(@selector(topScoreHistory))


@interface Config : NSObject {

    NSUserDefaults                                      *defaults;

    NSArray                                             *updateTriggers;
    NSDictionary                                        *resetTriggers;
}


@property (nonatomic, readwrite, retain) NSNumber       *fontSize;
@property (nonatomic, readwrite, retain) NSNumber       *largeFontSize;
@property (nonatomic, readwrite, retain) NSNumber       *smallFontSize;
@property (nonatomic, readwrite, retain) NSString       *fontName;
@property (nonatomic, readwrite, retain) NSString       *fixedFontName;

@property (nonatomic, readwrite, retain) NSNumber       *shadeColor;
@property (nonatomic, readwrite, retain) NSNumber       *transitionDuration;

@property (nonatomic, readwrite, retain) NSArray        *tracks;
@property (nonatomic, readwrite, retain) NSArray        *trackNames;
@property (nonatomic, readonly) NSString                *randomTrack;
@property (nonatomic, readwrite, retain) NSString       *currentTrack;
@property (nonatomic, readonly) NSString                *currentTrackName;

@property (nonatomic, readwrite, retain) NSNumber       *soundFx;
@property (nonatomic, readwrite, retain) NSNumber       *voice;
@property (nonatomic, readwrite, retain) NSNumber       *vibration;
@property (nonatomic, readwrite, retain) NSNumber       *visualFx;

@property (nonatomic, readwrite, retain) NSNumber       *score;
@property (nonatomic, readwrite, retain) NSDictionary   *topScoreHistory;

+(Config *)                                             get;

-(void) recordScore:(NSInteger)score;

@end
