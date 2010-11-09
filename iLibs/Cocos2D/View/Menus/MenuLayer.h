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
//  MenuLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 29/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "Resettable.h"
#import "ShadeLayer.h"

typedef enum MenuLayout {
    MenuLayoutVertical,
    MenuLayoutColumns,
} MenuLayout;

@class MenuLayer;

@protocol MenuDelegate

@optional
/** Occurs after the CCMenu layer was (re)constructed. */
- (void)didLoad:(MenuLayer *)menuLayer;
/** Occurs after the CCMenu layer has been layed out according to the default layout
 *
 * It happens before -didEnter, and only if necessary.
 */
- (void)didLayout:(MenuLayer *)menuLayer;
/** Occurs after the MenuLayer has entered the view hierarchy. */
- (void)didEnter:(MenuLayer *)menuLayer;

@end


@interface MenuLayer : ShadeLayer <Resettable> {

@private
    NSArray                                                  *_items;
    CCMenu                                                     *_menu;
    CCMenuItem                                                 *_logo;
    CGPoint                                                  _offset;

    MenuLayout                                               _layout;
    BOOL                                                     _layoutDirty;

    id<NSObject, MenuDelegate>                               _delegate;
}

@property (readonly, retain) CCMenu                                   *menu;
@property (readwrite) MenuLayout                            layout;
@property (readwrite, copy) NSArray                         *items;
@property (readwrite, retain) CCMenuItem                      *logo;
@property (readwrite, assign) CGPoint                       offset;
@property (readwrite, retain) id<NSObject, MenuDelegate>    delegate;

+ (MenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                          items:(CCMenuItem *)menuItems, ... NS_REQUIRES_NIL_TERMINATION;
+ (MenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                 itemsFromArray:(NSArray *)menuItems;

- (id)initWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:aLogo items:(CCMenuItem *)menuItem, ...;
- (id)initWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo itemsFromArray:(NSArray *)menuItems;

@end
