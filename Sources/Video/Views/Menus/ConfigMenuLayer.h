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
//  ConfigMenuLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 29/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuLayer.h"


@protocol ConfigMenuDelegate

/** Return a string that will be the text label in the UI for the given setting. */
@optional
- (NSString *)labelForSetting:(SEL)setting;

/** Return an array of MenuItem*'s to add to the toggle for the given setting. */
@optional
- (NSMutableArray *)toggleItemsForSetting:(SEL)setting;

/** Return a node that conveys and allows toggling the given setting. */
@optional
- (MenuItem *)itemForSetting:(SEL)setting;

@end


@interface ConfigMenuLayer : MenuLayer {

    NSDictionary                         *_itemConfigs;
    id<NSObject, ConfigMenuDelegate>     _configDelegate;
}

@property (readwrite, retain) id<NSObject, ConfigMenuDelegate> configDelegate;

+ (ConfigMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(MenuItem *)aLogo
                             settings:(SEL)setting, ... NS_REQUIRES_NIL_TERMINATION;

+ (ConfigMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(MenuItem *)aLogo
                    settingsFromArray:(NSArray *)settings;

- (id)initWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(MenuItem *)aLogo
     settingsFromArray:(NSArray *)settings;

@end
