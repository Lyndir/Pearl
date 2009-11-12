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
//  MenuLayer.m
//  iLibs
//
//  Created by Maarten Billemont on 29/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "AbstractAppDelegate.h"
#import "MenuLayer.h"
#import "MenuItemSpacer.h"
#import "AudioController.h"


@interface ClickMenu : Menu

@end

@interface ClickMenu (Private)

-(MenuItem *) itemForTouch: (UITouch *) touch;

@end

@implementation ClickMenu

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    BOOL itemTouched = [super ccTouchBegan:touch withEvent:event];
    if (itemTouched && [self itemForTouch:touch].isEnabled)
        [[AudioController get] clickEffect];
    
    return itemTouched;
}

@end



@interface MenuLayer ()

- (void)doLoad;
- (void)doLayout;

@end

@implementation MenuLayer

@synthesize menu, items, layout, logo, delegate;


+ (MenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(MenuItem *)aLogo items:(MenuItem *)menuItem, ... {
    
    if (!menuItem)
        [NSException raise:NSInvalidArgumentException
                    format:@"No menu items passed."];
    
    va_list list;
    va_start(list, menuItem);
    MenuItem *item;
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:5];
    [menuItems addObject:menuItem];
    
    while ((item = va_arg(list, MenuItem*)))
        [menuItems addObject:item];
    va_end(list);
    
    return [self menuWithDelegate:aDelegate logo:aLogo itemsFromArray:[menuItems autorelease]];
}


+ (MenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:(MenuItem *)aLogo itemsFromArray:(NSArray *)menuItems {
    
    return [[[self alloc] initWithDelegate:aDelegate logo:aLogo itemsFromArray:menuItems] autorelease];
}


- (id)initWithDelegate:(id<NSObject, MenuDelegate>)aDelegate logo:aLogo itemsFromArray:(NSArray *)menuItems {
    
    if(!(self = [super init]))
        return nil;

    self.delegate       = aDelegate;
    logo                = [aLogo retain];
    items               = [menuItems retain];
    layout              = MenuLayoutVertical;
    
    return self;
}


- (void)setItems:(NSArray *)newItems {
    
    [items release];
    items = [newItems copy];
    
    [self reset];
}


- (void)setLogo:(MenuItem *)aLogo {

    [logo release];
    logo = [aLogo retain];
    
    [self reset];
}


- (void)onEnter {
    
    [self doLoad];
    
    if (layoutDirty) {
        if ([delegate respondsToSelector:@selector(didLayout:)])
            [delegate didLayout:self];
        layoutDirty = NO;
    }
    
    [super onEnter];

    if ([delegate respondsToSelector:@selector(didEnter:)])
        [delegate didEnter:self];
}


- (void)onExit {
    
    [super onExit];
}


- (void)reset {
    
    if(menu) {
        [menu removeAllChildrenWithCleanup:YES];
        [self removeChild:menu cleanup:YES];
        [menu release];
        menu = nil;
    }

    [self doLoad];
}


- (void)doLoad {
    
    if (menu)
        return;
    
    menu = [[ClickMenu alloc] initWithItems:nil vaList:nil];
    if (logo) {
        [menu addChild:logo];
        [menu addChild:[MenuItemSpacer spacerSmall]];
    }
    
    [self addChild:menu];
    [self doLayout];
    
    if ([delegate respondsToSelector:@selector(didLoad:)])
        [delegate didLoad:self];
    
    layoutDirty = YES;
}

- (void)doLayout {
    
    switch (layout) {
        case MenuLayoutVertical: {
            for (MenuItem *item in items)
                [menu addChild:item];

            [menu alignItemsVertically];
            break;
        }

        case MenuLayoutColumns: {
            NSNumber *rows[10] = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil };
            NSUInteger r = 0;

            if (logo) {
                rows[r++] = [NSNumber numberWithUnsignedInt:1];
                rows[r++] = [NSNumber numberWithUnsignedInt:1];
            }
            
            NSUInteger itemsLeft = [items count], i = 0;
            if (itemsLeft % 2)
                [NSException raise:NSInternalInconsistencyException format:@"Item amount must be even for columns layout."];
            
            for (; r < 10 && itemsLeft; r += 2) {
                if (itemsLeft >= 4) {
                    rows[r + 0] = [NSNumber numberWithUnsignedInt:2];
                    rows[r + 1] = [NSNumber numberWithUnsignedInt:2];
                    [menu addChild:[items objectAtIndex:i + 0]];
                    [menu addChild:[items objectAtIndex:i + 2]];
                    [menu addChild:[items objectAtIndex:i + 1]];
                    [menu addChild:[items objectAtIndex:i + 3]];
                    itemsLeft   -= 4;
                    i           += 4;
                } else {
                    // itemsLeft == 2
                    rows[r + 0] = [NSNumber numberWithUnsignedInt:1];
                    rows[r + 1] = [NSNumber numberWithUnsignedInt:1];
                    [menu addChild:[items objectAtIndex:i + 0]];
                    [menu addChild:[items objectAtIndex:i + 1]];
                    itemsLeft   -= 2;
                    i           += 2;
                }
            }

            [menu alignItemsInColumns:
             rows[0], rows[1], rows[2], rows[3], rows[4],
             rows[5], rows[6], rows[7], rows[8], rows[9], nil];
            break;
        }
        
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Unsupported layout format."];
    }
}


- (void)dealloc {
    
    [menu release];
    menu = nil;
    
    [super dealloc];
}

@end
