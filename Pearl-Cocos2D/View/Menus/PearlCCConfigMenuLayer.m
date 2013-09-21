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
//  PearlCCConfigMenuLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 29/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCConfigMenuLayer.h"
#import "PearlCocos2DStrings.h"
#import "PearlCCMenuItemTitle.h"

@interface PearlCCConfigMenuLayer ()

- (void)tapped:(id)sender;

@property (readwrite, retain) NSDictionary *itemConfigs;

@end

@implementation PearlCCConfigMenuLayer

@synthesize itemConfigs = _itemConfigs;
@synthesize configDelegate = _configDelegate;


+ (instancetype)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate
                                        logo:(CCMenuItem *)aLogo
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

    return [self menuWithDelegate:aDelegate logo:aLogo settingsFromArray:settings];
}


+ (instancetype)menuWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate
                                        logo:(CCMenuItem *)aLogo
                           settingsFromArray:(NSArray *)settings {

    return [[self alloc] initWithDelegate:aDelegate logo:aLogo settingsFromArray:settings];
}

- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
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

    return [self initWithDelegate:aDelegate logo:aLogo settingsFromArray:settings];
}

- (id)initWithDelegate:(id<NSObject, PearlCCMenuDelegate, PearlCCConfigMenuDelegate>)aDelegate logo:(CCMenuItem *)aLogo
     settingsFromArray:(NSArray *)settings {

    self.configDelegate = aDelegate;

    NSMutableDictionary *mutableItemConfigs = [NSMutableDictionary dictionaryWithCapacity:[settings count]];
    self.itemConfigs = mutableItemConfigs;

    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:[settings count]];
    for (NSString  *setting in settings) {
        SEL settingSel = NSSelectorFromString(setting);

        // Build the setting's toggle button.
        CCMenuItemToggle *menuItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(tapped:)];
        if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(toggleItemsForSetting:)]) {
            NSArray        *settingItems = [self.configDelegate toggleItemsForSetting:settingSel];
            NSMutableArray *subItems     = [NSMutableArray arrayWithCapacity:[settingItems count]];
            for (id settingItem in settingItems)
                if ([settingItem isKindOfClass:[CCMenuItem class]])
                    [subItems addObject:settingItem];
                else
                    [subItems addObject:[CCMenuItemFont itemWithString:[settingItem description]]];
            menuItem.subItems = subItems;
        }
        if (![menuItem.subItems count])
            menuItem.subItems      = [NSMutableArray arrayWithObjects:
                                                      [CCMenuItemFont itemWithString:[PearlCocos2DStrings get].menuConfigOff],
                                                      [CCMenuItemFont itemWithString:[PearlCocos2DStrings get].menuConfigOn],
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
        [mutableItemConfigs setObject:setting forKey:[NSValue valueWithPointer:(void *)menuItem]];
        [menuItems addObject:[PearlCCMenuItemTitle itemWithString:label]];
        [menuItems addObject:menuItem];
    }

    return [super initWithDelegate:aDelegate logo:aLogo itemsFromArray:menuItems];
}


- (void)onEnter {

    [super onEnter];

    for (NSValue *itemValue in [self.itemConfigs allKeys]) {
        NSString         *selector = [self.itemConfigs objectForKey:itemValue];
        CCMenuItemToggle *item     = [itemValue pointerValue];

        id  t = [PearlConfig get];
        SEL s = NSSelectorFromString(selector);

        // Search t's class hierarchy for the selector.
        NSMethodSignature *sig = [t methodSignatureForSelector:s];
        if (!sig)
            [NSException raise:NSInternalInconsistencyException format:@"Couldn't find signature for %@ on %@", NSStringFromSelector(s), t];

        // Build an invocation for the signature & invoke it.
        __unsafe_unretained id ret;
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
                wrn(@"Couldn't obtain config menu item index for setting: %@, value: %@", NSStringFromSelector(s), ret);
                index = 0;
            }
        }

        item.selectedIndex = index;
    }
}


- (void)tapped:(CCMenuItemToggle *)toggle {

    id  t            = [PearlConfig get];
    SEL s            = [self configForItem:toggle];
    SEL setterS      = NSSelectorFromString([NSStringFromSelector(s) getterToSetter]);
    id  toggledValue = nil;
    if (self.configDelegate && [self.configDelegate respondsToSelector:@selector(valueForSetting:index:)])
        toggledValue = [self.configDelegate valueForSetting:s index:[toggle selectedIndex]];
    if (!toggledValue)
        toggledValue = [NSNumber numberWithUnsignedInteger:[toggle selectedIndex]];
    dbg(@"Setting %@ to %@", NSStringFromSelector(s), toggledValue);

    // Search t's class hierarchy for the selector.
    NSMethodSignature *sig = [t methodSignatureForSelector:setterS];
    if (!sig)
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't find signature for %@ on %@", NSStringFromSelector(s), t];

    // Build an invocation for the signature & invoke it.
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:t];
    [invocation setSelector:setterS];
    __unsafe_unretained id argument = toggledValue;
    [invocation setArgument:&argument atIndex:2];
    [invocation invoke];
}


- (SEL)configForItem:(CCMenuItemToggle *)item {

    return NSSelectorFromString([self.itemConfigs objectForKey:[NSValue valueWithPointer:(void *)item]]);
}


- (CCMenuItemToggle *)itemForConfig:(SEL)config {

    NSString     *configString = NSStringFromSelector(config);
    for (NSValue *itemValue in [self.itemConfigs allKeys])
        if ([[self.itemConfigs objectForKey:itemValue] isEqualToString:configString])
            return [itemValue pointerValue];

    return nil;
}

@end
