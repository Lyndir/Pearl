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
//  PearlCCActivitySprite.m
//  Pearl
//
//  Created by Maarten Billemont on 28/12/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCActivitySprite.h"

@interface PearlCCActivitySprite ()

@property (nonatomic, readwrite, retain) CCSprite *sprite;

@end

@implementation PearlCCActivitySprite

@synthesize sprite = _sprite;

- (id)init {

    if (!(self = [super initWithFile:@"wheel.png" capacity:32]))
        return nil;

    CCAnimation *spinAnimation = [CCAnimation animationWithSpriteFrames:nil delay:0.03f];
    for (NSUInteger f = 0; f < 31; ++f)
        [spinAnimation addSpriteFrameWithTexture:self.texture rect:CGRectMake(f * 32, 0, 32, 32)];

    self.sprite = [CCSprite spriteWithTexture:self.texture rect:((CCSpriteFrame *)[[spinAnimation frames] lastObject]).rect];
    [self.sprite setBatchNode:self];
    [self addChild:self.sprite];
    [self.sprite runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:spinAnimation]]];

    return self;
}

@end
