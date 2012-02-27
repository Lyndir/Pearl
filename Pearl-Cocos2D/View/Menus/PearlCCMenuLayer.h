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
//  PearlCCMenuLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 29/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"
#import "PearlResettable.h"
#import "PearlCCShadeLayer.h"

typedef enum MenuLayout {
    MenuLayoutVertical,
    MenuLayoutColumns,
    MenuLayoutCustomColumns,
    MenuLayoutCustomRows,
} MenuLayout;

@class PearlCCMenuLayer;

@protocol MenuDelegate

@optional
/** Occurs after the CCMenu layer was (re)constructed. */
- (void)didLoad:(PearlCCMenuLayer *)menuLayer;
/** Occurs after the CCMenu layer has been layed out according to the default layout
 *
 * It happens before -didEnter, and only if necessary.
 */
- (void)didLayout:(PearlCCMenuLayer *)menuLayer;
/** Occurs after the MenuLayer has entered the view hierarchy. */
- (void)didEnter:(PearlCCMenuLayer *)menuLayer;

@end


@interface PearlCCMenuLayer : PearlCCShadeLayer <PearlResettable> {

@private
    NSArray                                                         *_items;
    CCMenu                                                          *_menu;
    CCMenuItem                                                      *_logo;
    CGPoint                                                         _offset;

    MenuLayout                                                      _layout;
    BOOL                                                            _layoutDirty;

    id<NSObject, MenuDelegate>                                      _delegate;

    NSArray                                                         *_itemCounts;
}

@property (nonatomic, readonly, retain) CCMenu                      *menu;
@property (nonatomic, readwrite) MenuLayout                         layout;
@property (nonatomic, readwrite, copy) NSArray                      *items;
@property (nonatomic, readwrite, retain) CCMenuItem                 *logo;
@property (nonatomic, readwrite, assign) CGPoint                    offset;
@property (nonatomic, readwrite, retain) id<NSObject, MenuDelegate> delegate;
@property (nonatomic, readwrite, retain) NSArray                    *itemCounts;

+ (PearlCCMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                          items:(CCMenuItem *)menuItems, ... NS_REQUIRES_NIL_TERMINATION;
+ (PearlCCMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                 itemsFromArray:(NSArray *)menuItems;

- (id)initWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:aLogo items:(CCMenuItem *)menuItem, ...;
- (id)initWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo itemsFromArray:(NSArray *)menuItems;

@end
