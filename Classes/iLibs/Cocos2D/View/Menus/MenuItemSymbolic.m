//
//  MenuItemSymbolic.m
//  Deblock
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemSymbolic.h"


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
    
    NSString *oldFontName   = [MenuItemFont fontName];
    NSUInteger oldFontSize  = [MenuItemFont fontSize];
    [MenuItemFont setFontName:[Config get].symbolicFontName];
    [MenuItemFont setFontSize:[[Config get].largeFontSize unsignedIntValue]];

    @try {
        self = ([super initFromString:symbol target:aTarget selector:aSelector]);
    }
    
    @finally {
        [MenuItemFont setFontName:oldFontName];
        [MenuItemFont setFontSize:oldFontSize];
    }

    return self;
}

@end
