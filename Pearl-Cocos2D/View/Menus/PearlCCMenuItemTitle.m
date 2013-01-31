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
//  PearlCCMenuItemTitle.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuItemTitle.h"

@implementation PearlCCMenuItemTitle


+ (instancetype)itemWithString:(NSString *)title {

    return [[self alloc] initWithString:title];
}

- (id)initWithString:(NSString *)title {

    NSString *oldFontName = [CCMenuItemFont fontName];
    NSUInteger oldFontSize = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:[PearlConfig get].fixedFontName];
    [CCMenuItemFont setFontSize:[[PearlConfig get].smallFontSize unsignedIntegerValue]];

    self = ([super initWithString:title target:nil selector:nil]);

    [CCMenuItemFont setFontName:oldFontName];
    [CCMenuItemFont setFontSize:oldFontSize];

    if (!self)
        return nil;

    [self setIsEnabled:NO];

    return self;
}

@end
