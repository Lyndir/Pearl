//
//  MenuItemTitle.m
//  Pearl
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemTitle.h"
#import "Config.h"


@implementation MenuItemTitle



+ (MenuItemTitle *)itemFromString:(NSString *)title {
    
    return [[[self alloc] initFromString:title] autorelease];
}

- (id)initFromString:(NSString *)title {
    
    NSString *oldFontName   = [CCMenuItemFont fontName];
    NSUInteger oldFontSize  = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:[Config get].fixedFontName];
    [CCMenuItemFont setFontSize:[[Config get].smallFontSize intValue]];
    
    self = ([super initFromString:title target:nil selector:nil]);
    
    [CCMenuItemFont setFontName:oldFontName];
    [CCMenuItemFont setFontSize:oldFontSize];

    if (!self)
        return nil;
    
    [self setIsEnabled:NO];
    
    return self;
}

@end
