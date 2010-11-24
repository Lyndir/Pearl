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

#import "cocos2d.h"
#import "MenuLayer.h"


@protocol ConfigMenuDelegate

@optional
/** Return a string that will be the text label in the UI for the given setting. */
- (NSString *)labelForSetting:(SEL)setting;

/** Return an array of CCMenuItem*'s to add to the toggle for the given setting. */
- (NSArray *)toggleItemsForSetting:(SEL)setting;

/** Return a node that conveys and allows toggling the given setting. */
- (CCMenuItem *)itemForSetting:(SEL)setting;

/** Return the index of the item to select for the setting when its value is the given value.
 * @return NSUIntegerMax to use the default implementation for determining the index.
 */
- (NSUInteger)indexForSetting:(SEL)setting value:(id)value;

/** Return the value to assign to the setting after toggling to the given index */
- (id)valueForSetting:(SEL)setting index:(NSUInteger)index;

@end


@interface ConfigMenuLayer : MenuLayer {

    NSDictionary                                                            *_itemConfigs;
    id<NSObject, ConfigMenuDelegate>                                        _configDelegate;
}

@property (nonatomic, readwrite, retain) id<NSObject, ConfigMenuDelegate>   configDelegate;

+ (ConfigMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                             settings:(SEL)setting, ... NS_REQUIRES_NIL_TERMINATION;

+ (ConfigMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                    settingsFromArray:(NSArray *)settings;

- (id)initWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
              settings:(SEL)setting, ...;

- (id)initWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
     settingsFromArray:(NSArray *)settings;

@end
