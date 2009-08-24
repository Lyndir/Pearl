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

#import "MenuLayer.h"
#import "MenuItemSpacer.h"
#import "AudioController.h"


@interface ClickMenu : Menu

@end

@implementation ClickMenu

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    BOOL itemTouched = [super ccTouchBegan:touch withEvent:event];
    if (itemTouched)
        [[AudioController get] clickEffect];
    
    return itemTouched;
}

@end



@interface MenuLayer ()

- (void)load;

@end

@implementation MenuLayer

@synthesize logo, items;


+ (MenuLayer *)menuWithItems:(MenuItem *)menuItem, ... {
    
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
    
    return [self menuWithItemsFromArray:[menuItems autorelease]];
}


+ (MenuLayer *)menuWithItemsFromArray:(NSArray *)menuItems {
    
    return [[[self alloc] initWithItemsFromArray:menuItems] autorelease];
}


- (id)initWithItemsFromArray:(NSArray *)menuItems {
    
    if(!(self = [super init]))
        return nil;

    self.items = menuItems;
    
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
    
    [self load];
    
    [super onEnter];
}


- (void)onExit {
    
    [super onExit];
}


-(void) reset {
    
    if(menu) {
        [menu removeAllChildrenWithCleanup:YES];
        [self removeChild:menu cleanup:YES];
        [menu release];
        menu = nil;
    }

    [self load];
}


- (void)load {
    
    if (menu)
        return;
    
    menu = [[ClickMenu alloc] initWithItems:nil vaList:nil];
    if (logo) {
        [menu addChild:logo];
        [menu addChild:[MenuItemSpacer spacerSmall]];
    }
    for (MenuItem *item in items)
        [menu addChild:item];
    [menu alignItemsVertically];
    [self addChild:menu];
}


-(void) dealloc {
    
    [menu release];
    menu = nil;
    
    [super dealloc];
}

@end
