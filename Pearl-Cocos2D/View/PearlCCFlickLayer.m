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
//  PearlCCFlickLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 22/10/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCFlickLayer.h"
#import "PearlConfig.h"


@interface PearlCCFlickLayer ()

- (void)right:(id)sender;
- (void)left:(id)sender;
    
@property (readwrite, retain) PearlCCScrollLayer *content;

@property (readwrite, retain) CCMenuItem             *right;
@property (readwrite, retain) CCMenuItem             *left;

@end


@implementation PearlCCFlickLayer

@synthesize content = _content;
@synthesize right = _right, left = _left;

+ (PearlCCFlickLayer *)flickSprites:(CCSprite *)firstSprite, ... {
    
    va_list list;
    va_start(list, firstSprite);
    
    NSMutableArray *sprites = [[NSMutableArray alloc] initWithCapacity:3];
    for (CCSprite *sprite = firstSprite; sprite; sprite = va_arg(list, CCSprite*)) {
        [sprites addObject:sprite];
    }
    va_end(list);
    
    return [self flickSpritesFromArray:[sprites autorelease]];
}


+ (PearlCCFlickLayer *)flickSpritesFromArray:(NSArray *)sprites {
    
    return [[[self alloc] initWithSpritesFromArray:sprites] autorelease];
}


- (id)initWithSprites:(CCSprite*)firstSprite, ... {
    
    va_list list;
    va_start(list, firstSprite);
    
    NSMutableArray *sprites = [[NSMutableArray alloc] initWithCapacity:3];
    for (CCSprite *sprite = firstSprite; sprite; sprite = va_arg(list, CCSprite*)) {
        [sprites addObject:sprite];
    }
    va_end(list);

    return [self initWithSpritesFromArray:[sprites autorelease]];
}

- (id)initWithSpritesFromArray:(NSArray *)sprites {
    
    if (!(self = [super init]))
        return nil;
    
    self.content                 = [PearlCCScrollLayer scrollWithContentSize:CGSizeZero direction:ScrollContentDirectionLeftToRight];
    self.content.delegate        = self;
    [self addChild:self.content];
    
    NSString *oldFontName   = [CCMenuItemFont fontName];
    NSUInteger oldFontSize  = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:[PearlConfig get].symbolicFontName];
    [CCMenuItemFont setFontSize:[[PearlConfig get].largeFontSize unsignedIntValue]];
    self.right                   = [CCMenuItemFont itemFromString:@" ▹ "
                                                         target:self selector:@selector(right:)];
    self.left                    = [CCMenuItemFont itemFromString:@" ◃ "
                                                         target:self selector:@selector(left:)];
    [CCMenuItemFont setFontName:oldFontName];
    [CCMenuItemFont setFontSize:oldFontSize];
    
    [self addChild:[CCMenu menuWithItems:self.right, nil]];
    [self addChild:[CCMenu menuWithItems:self.left, nil]];
    self.right.position          = ccp(self.contentSize.width / 2, 0);
    self.right.anchorPoint       = ccp(1, 0.5f);
    self.left.position           = ccp(-self.contentSize.width / 2, 0);
    self.left.anchorPoint        = ccp(0, 0.5f);
    
    CGFloat x = 0;
    for (CCSprite *sprite in sprites) {
        [self.content addChild:sprite];
        
        sprite.position             = ccp(x + self.contentSize.width / 2, self.contentSize.height / 2);
        sprite.anchorPoint          = ccp(0.5f, 0.5f);
        x += self.contentSize.width;
    }
    
    self.content.scrollRatio             = ccp(1.0f, 0.0f);
    self.content.scrollContentSize       = CGSizeMake(x, 0);
    self.content.scrollStep              = ccp(self.contentSize.width, 0);
    
    return self;
}

-(void)didUpdateScrollWithOrigin:(CGPoint)origin to:(CGPoint)newScroll {
    
    self.right.visible                   = [self.content isScrollValid:ccpMult(self.content.scrollStep, -1)];
    self.left.visible                    = [self.content isScrollValid:self.content.scrollStep];
}

- (void)right:(id)sender {
    
    [self.content scrollBy:ccpMult(self.content.scrollStep, -1)];
}

- (void)left:(id)sender {
    
    [self.content scrollBy:self.content.scrollStep];
}


- (void)dealloc {

    self.content = nil;
    self.right = nil;
    self.left = nil;

    [super dealloc];
}

@end
