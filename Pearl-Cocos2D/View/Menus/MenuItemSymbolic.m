//
//  MenuItemSymbolic.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemSymbolic.h"
#import "Config.h"


@implementation MenuItemSymbolic



+ (MenuItemSymbolic *)itemFromString:(NSString *)symbol {

    return [self itemFromString:symbol target:nil selector:nil];
}

+ (MenuItemSymbolic *)itemFromString:(NSString *)symbol target:(id)aTarget selector:(SEL)aSelector {
    
    return [[[self alloc] initFromString:symbol target:aTarget selector:aSelector] autorelease];
}


- (id)initFromString:(NSString *)symbol {

    return [self initFromString:symbol target:nil selector:nil];
}


- (id)initFromString:(NSString *)symbol target:(id)aTarget selector:(SEL)aSelector {
    
    NSString *oldFontName   = [CCMenuItemFont fontName];
    NSUInteger oldFontSize  = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:[Config get].symbolicFontName];
    [CCMenuItemFont setFontSize:[[Config get].largeFontSize unsignedIntValue]];

    @try {
        self = ([super initFromString:symbol target:aTarget selector:aSelector]);
    }
    
    @finally {
        [CCMenuItemFont setFontName:oldFontName];
        [CCMenuItemFont setFontSize:oldFontSize];
    }

    return self;
}

@end
