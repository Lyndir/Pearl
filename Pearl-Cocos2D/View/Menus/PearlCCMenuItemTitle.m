//
//  PearlCCMenuItemTitle.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuItemTitle.h"
#import "PearlConfig.h"


@implementation PearlCCMenuItemTitle



+ (PearlCCMenuItemTitle *)itemWithString:(NSString *)title {
    
    return [[[self alloc] initWithString:title] autorelease];
}

- (id)initWithString:(NSString *)title {
    
    NSString *oldFontName   = [CCMenuItemFont fontName];
    NSUInteger oldFontSize  = [CCMenuItemFont fontSize];
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
