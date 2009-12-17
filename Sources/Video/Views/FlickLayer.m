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
//  FlickLayer.m
//  iLibs
//
//  Created by Maarten Billemont on 22/10/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "FlickLayer.h"


@interface FlickLayer ()

- (void)right:(id)sender;
- (void)left:(id)sender;
    
@end


@implementation FlickLayer

+ (FlickLayer *)flickSprites:(Sprite *)firstSprite, ... {
    
    va_list list;
    va_start(list, firstSprite);
    
    NSMutableArray *sprites = [[NSMutableArray alloc] initWithCapacity:3];
    for (Sprite *sprite = firstSprite; sprite; sprite = va_arg(list, Sprite*)) {
        [sprites addObject:sprite];
    }
    va_end(list);
    
    return [self flickSpritesFromArray:[sprites autorelease]];
}


+ (FlickLayer *)flickSpritesFromArray:(NSArray *)sprites {
    
    return [[[self alloc] initWithSpritesFromArray:sprites] autorelease];
}


- (id)initWithSprites:(Sprite*)firstSprite, ... {
    
    va_list list;
    va_start(list, firstSprite);
    
    NSMutableArray *sprites = [[NSMutableArray alloc] initWithCapacity:3];
    for (Sprite *sprite = firstSprite; sprite; sprite = va_arg(list, Sprite*)) {
        [sprites addObject:sprite];
    }
    va_end(list);

    return [self initWithSpritesFromArray:[sprites autorelease]];
}

- (id)initWithSpritesFromArray:(NSArray *)sprites {
    
    if (!(self = [super init]))
        return nil;
    
    content                 = [[ScrollLayer alloc] initWithContentSize:CGSizeZero direction:ScrollContentDirectionLeftToRight];
    content.delegate        = self;
    [self addChild:content];
    
    NSString *oldFontName   = [MenuItemFont fontName];
    NSUInteger oldFontSize  = [MenuItemFont fontSize];
    [MenuItemFont setFontName:[Config get].symbolicFontName];
    [MenuItemFont setFontSize:[[Config get].largeFontSize unsignedIntValue]];
    right                   = [[MenuItemFont itemFromString:@" ▹ "
                                                     target:self selector:@selector(right:)] retain];
    left                    = [[MenuItemFont itemFromString:@" ◃ "
                                                     target:self selector:@selector(left:)] retain];
    [MenuItemFont setFontName:oldFontName];
    [MenuItemFont setFontSize:oldFontSize];
    
    [self addChild:[Menu menuWithItems:right, nil]];
    [self addChild:[Menu menuWithItems:left, nil]];
    right.position          = ccp(self.contentSize.width / 2, 0);
    right.anchorPoint       = ccp(1, 0.5f);
    left.position           = ccp(-self.contentSize.width / 2, 0);
    left.anchorPoint        = ccp(0, 0.5f);
    
    CGFloat x = 0;
    for (Sprite *sprite in sprites) {
        [content addChild:sprite];
        
        sprite.position             = ccp(x + self.contentSize.width / 2, self.contentSize.height / 2);
        sprite.anchorPoint          = ccp(0.5f, 0.5f);
        x += self.contentSize.width;
    }
    
    content.scrollRatio             = ccp(1.0f, 0.0f);
    content.scrollContentSize       = CGSizeMake(x, 0);
    content.scrollStep              = ccp(self.contentSize.width, 0);
    
    return self;
}

-(void)didUpdateScrollWithOrigin:(CGPoint)origin to:(CGPoint)newScroll {
    
    right.visible                   = [content isScrollValid:ccpMult(content.scrollStep, -1)];
    left.visible                    = [content isScrollValid:content.scrollStep];
}

- (void)right:(id)sender {
    
    [content scrollBy:ccpMult(content.scrollStep, -1)];
}

- (void)left:(id)sender {
    
    [content scrollBy:content.scrollStep];
}


@end
