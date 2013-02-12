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
//  PearlCCMenuItemSymbolic.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuItemSymbolic.h"

@implementation PearlCCMenuItemSymbolic


+ (instancetype)itemWithString:(NSString *)symbol {

    return [self itemWithString:symbol target:nil selector:nil];
}

+ (instancetype)itemWithString:(NSString *)symbol target:(id)aTarget selector:(SEL)aSelector {

    return [[self alloc] initWithString:symbol target:aTarget selector:aSelector];
}


- (id)initWithString:(NSString *)symbol {

    return [self initWithString:symbol target:nil selector:nil];
}


- (id)initWithString:(NSString *)symbol target:(id)aTarget selector:(SEL)aSelector {

    NSString *oldFontName = [CCMenuItemFont fontName];
    NSUInteger oldFontSize = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:[PearlConfig get].symbolicFontName];
    [CCMenuItemFont setFontSize:[[PearlConfig get].largeFontSize unsignedIntegerValue]];

    @try {
        self = ([super initWithString:symbol target:aTarget selector:aSelector]);
    }

    @finally {
        [CCMenuItemFont setFontName:oldFontName];
        [CCMenuItemFont setFontSize:oldFontSize];
    }

    return self;
}

@end
