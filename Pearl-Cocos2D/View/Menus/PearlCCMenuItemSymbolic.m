//
//  PearlCCMenuItemSymbolic.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuItemSymbolic.h"
#import "PearlConfig.h"


@implementation PearlCCMenuItemSymbolic



+ (PearlCCMenuItemSymbolic *)itemWithString:(NSString *)symbol {

    return [self itemWithString:symbol target:nil selector:nil];
}

+ (PearlCCMenuItemSymbolic *)itemWithString:(NSString *)symbol target:(id)aTarget selector:(SEL)aSelector {
    
    return [[[self alloc] initWithString:symbol target:aTarget selector:aSelector] autorelease];
}


- (id)initWithString:(NSString *)symbol {

    return [self initWithString:symbol target:nil selector:nil];
}


- (id)initWithString:(NSString *)symbol target:(id)aTarget selector:(SEL)aSelector {
    
    NSString *oldFontName   = [CCMenuItemFont fontName];
    NSUInteger oldFontSize  = [CCMenuItemFont fontSize];
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
