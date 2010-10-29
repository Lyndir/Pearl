/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  ActivitySprite.m
//  iLibs
//
//  Created by Maarten Billemont on 28/12/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "ActivitySprite.h"


@interface ActivitySprite ()

@property (readwrite, retain) AtlasSprite   *sprite;

@end

@implementation ActivitySprite

@synthesize sprite = _sprite;

- (id)init {
    
    if (!(self = [super initWithFile:@"wheel.png" capacity:31]))
        return nil;

    AtlasAnimation *spinAnimation = [AtlasAnimation animationWithName:@"spin" delay:0.03f];
    for (NSUInteger f = 0; f < 31; ++f)
        [spinAnimation addFrameWithRect:CGRectMake(f * 32, 0, 32, 32)];
    
    self.sprite = [AtlasSprite spriteWithRect:((AtlasSpriteFrame *) [[spinAnimation frames] lastObject]).rect
                           spriteManager:self];
    [self addChild:self.sprite];
    [self.sprite runAction:[RepeatForever actionWithAction:[Animate actionWithAnimation:spinAnimation]]];
    
    return self;
}

@end
