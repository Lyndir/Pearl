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
//  PearlCCMenuItemSpacer.m
//  Pearl
//
//  Created by Maarten Billemont on 02/03/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuItemSpacer.h"

@interface PearlCCMenuItemSpacer ()

@property (readwrite, assign) CGFloat height;

@end


@implementation PearlCCMenuItemSpacer

@synthesize height = _height;

+ (instancetype)spacerSmall {

    return [[self alloc] initSmall];
}

+ (instancetype)spacerNormal {

    return [[self alloc] initNormal];
}

+ (instancetype)spacerLarge {

    return [[self alloc] initLarge];
}

- (id)initSmall {

    return [self initWithHeight:[[PearlConfig get].smallFontSize unsignedIntegerValue]];
}

- (id)initNormal {

    return [self initWithHeight:[[PearlConfig get].fontSize unsignedIntegerValue]];
}

- (id)initLarge {

    return [self initWithHeight:[[PearlConfig get].largeFontSize unsignedIntegerValue]];
}


- (id)initWithHeight:(CGFloat)aHeight {

    if (!(self = [super initWithTarget:nil selector:nil]))
        return self;

    self.height = aHeight;
    [self setIsEnabled:NO];

    return self;
}


- (CGRect)rect {

    return CGRectMake(self.position.x, self.position.y - self.height / 2, self.position.x, self.position.y + self.height / 2);
}


- (CGSize)contentSize {

    return CGSizeMake(0, self.height);
}


@end
