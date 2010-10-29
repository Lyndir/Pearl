//
//  MenuItemTitle.m
//  Deblock
//
//  Created by Maarten Billemont on 08/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "MenuItemTitle.h"
#import "Config.h"


@implementation MenuItemTitle



+ (MenuItemTitle *)itemWithString:(NSString *)title {
    
    return [[[self alloc] initWithString:title] autorelease];
}

- (id)initWithString:(NSString *)title {
    
    NSString *oldFontName   = [MenuItemFont fontName];
    NSUInteger oldFontSize  = [MenuItemFont fontSize];
    [MenuItemFont setFontName:[Config get].fixedFontName];
    [MenuItemFont setFontSize:[[Config get].smallFontSize intValue]];
    
    self = ([super initFromString:title target:nil selector:nil]);
    
    [MenuItemFont setFontName:oldFontName];
    [MenuItemFont setFontSize:oldFontSize];

    if (!self)
        return nil;
    
    [self setIsEnabled:NO];
    
    return self;
}

@end
