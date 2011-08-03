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
//  ConfigMenuLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 29/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "ConfigMenuLayer.h"
#import "Config.h"
#import "MenuItemTitle.h"
#import "NSString_SEL.h"
#import "StringUtils.h"


@interface ConfigMenuLayer ()

- (void)tapped:(id)sender;

@property (readwrite, retain) NSDictionary                         *itemConfigs;

@end

@implementation ConfigMenuLayer

@synthesize itemConfigs = _itemConfigs;
@synthesize configDelegate = _configDelegate;



+ (ConfigMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                             settings:(SEL)setting, ... {

    if (!setting)
        [NSException raise:NSInvalidArgumentException
                    format:@"No menu items passed."];

    va_list list;
    va_start(list, setting);
    SEL item;
    NSMutableArray *settings = [[NSMutableArray alloc] initWithCapacity:5];
    [settings addObject:NSStringFromSelector(setting)];

    while ((item = va_arg(list, SEL)))
        [settings addObject:NSStringFromSelector(item)];
    va_end(list);

    return [self menuWithDelegate:aDelegate logo:aLogo settingsFromArray:[settings autorelease]];
}


+ (ConfigMenuLayer *)menuWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                    settingsFromArray:(NSArray *)settings {

    return [[[self alloc] initWithDelegate:aDelegate logo:aLogo settingsFromArray:settings] autorelease];
}

- (id)initWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
                             settings:(SEL)setting, ... {

    if (!setting)
        [NSException raise:NSInvalidArgumentException
                    format:@"No menu items passed."];

    va_list list;
    va_start(list, setting);
    SEL item;
    NSMutableArray *settings = [[NSMutableArray alloc] initWithCapacity:5];
    [settings addObject:NSStringFromSelector(setting)];

    while ((item = va_arg(list, SEL)))
        [settings addObject:NSStringFromSelector(item)];
    va_end(list);

    return [self initWithDelegate:aDelegate logo:aLogo settingsFromArray:[settings autorelease]];
}

- (id)initWithDelegate:(id<NSObject, MenuDelegate, ConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
     settingsFromArray:(NSArray *)settings {

    self.configDelegate = aDelegate;

    NSMutableDictionary *mutableItemConfigs = [NSMutableDictionary dictionaryWithCapacity:[settings count]];
    self.itemConfigs = mutableItemConfigs;

    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:[settings count]];
    for (NSString *setting in settings) {
        SEL settingSel = NSSelectorFromString(setting);

        // Build the setting's toggle button.
        CCMenuItemToggle *menuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(tapped:)];
        if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(toggleItemsForSetting:)]) {
            NSArray *settingItems = [self.configDelegate toggleItemsForSetting:settingSel];
            NSMutableArray *subItems = [NSMutableArray arrayWithCapacity:[settingItems count]];
            for (id settingItem in settingItems)
                if ([settingItem isKindOfClass:[CCMenuItem class]])
                    [subItems addObject:settingItem];
                else
                    [subItems addObject:[CCMenuItemFont itemFromString:[settingItem description]]];
            menuItem.subItems = subItems;
        }
        if (![menuItem.subItems count])
            menuItem.subItems = [NSMutableArray arrayWithObjects:
                                 [CCMenuItemFont itemFromString:[PearlCocos2DStrings get].menuConfigOff],
                                 [CCMenuItemFont itemFromString:[PearlCocos2DStrings get].menuConfigOn],
                                 nil];

        // Force update.
        [menuItem setSelectedIndex:[menuItem.subItems count] - 1];

        // Build the setting's label.
        NSString *label = nil;
        if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(labelForSetting:)])
            label = [self.configDelegate labelForSetting:settingSel];
        if (!label)
            label = setting;

        // Add the setting to the menu.
        [mutableItemConfigs setObject:setting forKey:[NSValue valueWithPointer:menuItem]];
        [menuItems addObject:[MenuItemTitle itemFromString:label]];
        [menuItems addObject:menuItem];
    }

    return [super initWithDelegate:aDelegate logo:aLogo itemsFromArray:[menuItems autorelease]];
}


- (void)onEnter {

    [super onEnter];

    for (NSValue *itemValue in [self.itemConfigs allKeys]) {
        NSString *selector = [self.itemConfigs objectForKey:itemValue];
        CCMenuItemToggle *item = [itemValue pointerValue];

        id t = [Config get];
        SEL s = NSSelectorFromString(selector);

        // Search t's class hierarchy for the selector.
        NSMethodSignature *sig = [t methodSignatureForSelector:s];
        if (!sig)
            [NSException raise:NSInternalInconsistencyException format:@"Couldn't find signature for %s on %@", s, t];

        // Build an invocation for the signature & invoke it.
        id ret;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setSelector:s];
        [invocation invokeWithTarget:t];
        [invocation getReturnValue:&ret];

        NSUInteger index = NSUIntegerMax;
        if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(indexForSetting:value:)])
            index = [self.configDelegate indexForSetting:s value:ret];
        if (index == NSUIntegerMax) {
            if ([ret respondsToSelector:@selector(unsignedIntValue)])
                index = [ret unsignedIntValue];
            else {
                wrn(@"Couldn't obtain config menu item index for setting: %s, value: %@", s, ret);
                index = 0;
            }
        }

        item.selectedIndex = index;
    }
}


- (void)tapped:(CCMenuItemToggle *)toggle {

    id t = [Config get];
    SEL s = [self configForItem:toggle];
    SEL setterS = NSSelectorFromString([NSStringFromSelector(s) getterToSetter]);
    id toggledValue = nil;
    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(valueForSetting:index:)])
        toggledValue = [self.configDelegate valueForSetting:s index:[toggle selectedIndex]];
    if (!toggledValue)
        toggledValue = [NSNumber numberWithUnsignedInt:[toggle selectedIndex]];
    dbg(@"Setting %s to %@", s, toggledValue);

    // Search t's class hierarchy for the selector.
    NSMethodSignature *sig = [t methodSignatureForSelector:setterS];
    if (!sig)
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't find signature for %s on %@", s, t];

    // Build an invocation for the signature & invoke it.
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:t];
    [invocation setSelector:setterS];
    [invocation setArgument:&toggledValue atIndex:2];
    [invocation invoke];
}


- (SEL)configForItem:(CCMenuItemToggle *)item {
    
    return NSSelectorFromString([self.itemConfigs objectForKey:[NSValue valueWithPointer:item]]);
}


- (CCMenuItemToggle *)itemForConfig:(SEL)config {
    
    NSString *configString = NSStringFromSelector(config);
    for (NSValue *itemValue in [self.itemConfigs allKeys])
        if ([[self.itemConfigs objectForKey:itemValue] isEqualToString:configString])
            return [itemValue pointerValue];
    
    return nil;
}


- (void)dealloc {

    self.configDelegate = nil;
    self.itemConfigs = nil;

    [super dealloc];
}

@end
