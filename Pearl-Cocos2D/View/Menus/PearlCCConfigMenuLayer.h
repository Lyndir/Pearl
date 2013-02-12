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
//  PearlCCConfigMenuLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 29/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuLayer.h"


@protocol PearlCCConfigMenuDelegate

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


@interface PearlCCConfigMenuLayer : PearlCCMenuLayer {

    NSDictionary *_itemConfigs;
    id<NSObject, PearlCCConfigMenuDelegate> _configDelegate;
}

@property (nonatomic, readwrite, retain) id<NSObject, PearlCCConfigMenuDelegate> configDelegate;

+ (instancetype)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate
                            logo:(CCMenuItem *)aLogo
                        settings:(SEL)setting, ... NS_REQUIRES_NIL_TERMINATION;

+ (instancetype)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate
                            logo:(CCMenuItem *)aLogo
               settingsFromArray:(NSArray *)settings;

- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
              settings:(SEL)setting, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
     settingsFromArray:(NSArray *)settings;

- (SEL)configForItem:(CCMenuItemToggle *)item;
- (CCMenuItemToggle *)itemForConfig:(SEL)config;

@end
