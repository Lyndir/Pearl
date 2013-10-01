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
//  PearlCCMenuLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 29/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"
#import "PearlResettable.h"
#import "PearlCCShadeLayer.h"

typedef enum {
    PearlCCMenuLayoutVertical,
    PearlCCMenuLayoutColumns,
    PearlCCMenuLayoutCustomColumns,
    PearlCCMenuLayoutCustomRows
} PearlCCMenuLayout;

@class PearlCCMenuLayer;

@protocol PearlCCMenuDelegate

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


@interface PearlCCMenuLayer : PearlCCShadeLayer<PearlResettable> {

@private
    NSArray    *_items;
    CCMenu     *_menu;
    CCMenuItem *_logo;
    CGPoint _offset;

    PearlCCMenuLayout _layout;
    BOOL              _layoutDirty;

    id<NSObject, PearlCCMenuDelegate> _delegate;

    NSArray *_itemCounts;
}

@property (nonatomic, readonly, retain) CCMenu *menu;
@property (nonatomic, readwrite) PearlCCMenuLayout layout;
@property (nonatomic, readwrite, copy) NSArray      *items;
@property (nonatomic, readwrite, retain) CCMenuItem *logo;
@property (nonatomic, readwrite, assign) CGPoint                           offset;
@property (nonatomic, readwrite, retain) id<NSObject, PearlCCMenuDelegate> delegate;
@property (nonatomic, readwrite, retain) NSArray *itemCounts;

+ (instancetype)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                           items:(CCMenuItem *)menuItems, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                  itemsFromArray:(NSArray *)menuItems;

- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:aLogo
                 items:(CCMenuItem *)menuItem, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo itemsFromArray:(NSArray *)menuItems;

- (void)doLoad;

@end
