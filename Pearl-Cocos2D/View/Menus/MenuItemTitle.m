//
//  MenuItemTitle.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemTitle.h"
#import "PearlConfig.h"


@implementation MenuItemTitle



+ (MenuItemTitle *)itemFromString:(NSString *)title {
    
    return [[[self alloc] initFromString:title] autorelease];
}

- (id)initFromString:(NSString *)title {
    
    NSString *oldFontName   = [CCMenuItemFont fontName];
    NSUInteger oldFontSize  = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:[PearlConfig get].fixedFontName];
    [CCMenuItemFont setFontSize:[[PearlConfig get].smallFontSize intValue]];
    
    self = ([super initFromString:title target:nil selector:nil]);
    
    [CCMenuItemFont setFontName:oldFontName];
    [CCMenuItemFont setFontSize:oldFontSize];

    if (!self)
        return nil;
    
    [self setIsEnabled:NO];
    
    return self;
}

@end
