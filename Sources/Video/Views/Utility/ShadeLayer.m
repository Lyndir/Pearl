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
//  ShadeLayer.m
//  iLibs
//
//  Created by Maarten Billemont on 26/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "ShadeLayer.h"
#import "AbstractAppDelegate.h"
#import "Remove.h"


@interface ShadeLayer ()

- (void)_back:(CocosNode *)sender;
- (void)_next:(CocosNode *)sender;

@end


@implementation ShadeLayer

@synthesize backButton, nextButton, fadeNextEntry, background, backgroundOffset;


-(id) init {

    if(!(self = [super init]))
        return self;
    
    pushed                  = NO;
    fadeNextEntry           = YES;
    backgroundOffset        = CGPointZero;
    
    ccColor4B shadeColor    = ccc4l([[Config get].shadeColor longValue]);
    self.opacity            = shadeColor.a;
    self.color              = ccc4to3(shadeColor);
    
    NSString *oldFontName   = [MenuItemFont fontName];
    NSUInteger oldFontSize  = [MenuItemFont fontSize];
    [MenuItemFont setFontName:[Config get].symbolicFontName];
    [MenuItemFont setFontSize:[[Config get].largeFontSize unsignedIntValue]];
    backButton              = [[MenuItemFont itemFromString:@"   ◃   "
                                                     target:self
                                                   selector:@selector(_back:)] retain];
    [MenuItemFont setFontName:[Config get].symbolicFontName];
    [MenuItemFont setFontSize:[[Config get].largeFontSize unsignedIntValue]];
    nextButton              = [[MenuItemFont itemFromString:@"   ▹   "
                                                     target:self
                                                   selector:@selector(_next:)] retain];
    [MenuItemFont setFontName:oldFontName];
    [MenuItemFont setFontSize:oldFontSize];
    backMenu = [[Menu menuWithItems:backButton, nil] retain];
    backMenu.position = ccp([[Config get].fontSize unsignedIntValue] * 1.5f,
                            [[Config get].fontSize unsignedIntValue] * 1.5f);
    [backMenu alignItemsHorizontally];
    
    nextMenu = [[Menu menuWithItems:nextButton, nil] retain];
    nextMenu.position = ccp(contentSize.width - [[Config get].fontSize unsignedIntValue] * 1.5f,
                            [[Config get].fontSize unsignedIntValue] * 1.5f);
    [nextMenu alignItemsHorizontally];
    [self addChild:backMenu];
    [self addChild:nextMenu];

    [self setBackButtonTarget:self selector:@selector(back)];
    [self setNextButtonTarget:nil selector:nil];

    return self;
}


- (void) setBackButtonTarget:(id)target selector:(SEL)selector {

    [backInvocation release];
    
    if (target) {
        backInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [backInvocation setTarget:target];
        [backInvocation setSelector:selector];
        [backInvocation retain];
    } else
        backInvocation = nil;
    
    backMenu.visible = backInvocation != nil;
}


- (void) setNextButtonTarget:(id)target selector:(SEL)selector {
    
    [nextInvocation release];
    
    if (target) {
        nextInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [nextInvocation setTarget:target];
        [nextInvocation setSelector:selector];
        [nextInvocation retain];
    } else
        nextInvocation = nil;
    
    nextMenu.visible = nextInvocation != nil;
}


- (void)_back:(CocosNode *)sender {
    
    [backInvocation invoke];
}


- (void)_next:(CocosNode *)sender {
    
    [nextInvocation invoke];
}


- (void)back {
    
    [[AudioController get] clickEffect];
    [[AbstractAppDelegate get] popLayer];
}


-(void) onEnter {
        
    [self setPosition:ccp((pushed? -1: 1) * self.contentSize.width, 0)];

    [self stopAllActions];

    if ([[AbstractAppDelegate get] isLastLayerShowing]) {
        if ([backMenu parent])
            [self removeChild:backMenu cleanup:YES];
    } else {
        if (![backMenu parent])
            [self addChild:backMenu];
    }
    
    [super onEnter];
    
    self.visible = YES;
    [self runAction:[Sequence actions:
                     [EaseSineOut actionWithAction:
                      [MoveTo actionWithDuration:[[Config get].transitionDuration floatValue] position:CGPointZero]],
                     [CallFunc actionWithTarget:self selector:@selector(ready)],
                     nil]];
}


-(void) ready {
    
    // Override me.
}


-(void) dismissAsPush:(BOOL)isPushed {

    [self stopAllActions];
    
    pushed = isPushed;
    
    [self runAction:[Sequence actions:
                     [EaseSineIn actionWithAction:
                      [MoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                                        position:ccp((pushed? -1: 1) * self.contentSize.width, 0)]],
                     [CallFunc actionWithTarget:self selector:@selector(gone)],
                     [Remove action],
                     nil]];
}


-(void) gone {
    
    // Override me.
}


- (void)setBackground:(CocosNode *)aBackground {
    
    [background release];
    [self removeChild:background cleanup:YES];
    
    background = [aBackground retain];
    [self addChild:background z:-1];
    
    // Automatically set correct position of texture nodes.
    if (CGPointEqualToPoint(background.position, CGPointZero) && [background isKindOfClass:[Sprite class]])
        backgroundOffset = ccp(background.contentSize.width / 2, background.contentSize.height / 2);
}


- (void)setPosition:(CGPoint)newPosition {
    
    super.position      = newPosition;
    
    background.position = ccp(backgroundOffset.x - newPosition.x, backgroundOffset.y - newPosition.y);
    if ([background conformsToProtocol:@protocol(CocosNodeRGBA)] && fadeNextEntry)
        ((id<CocosNodeRGBA>)background).opacity  = 0xff * (1 - fabs(newPosition.x) / self.contentSize.width);
    
    if (CGPointEqualToPoint(newPosition, CGPointZero))
        fadeNextEntry   = YES;
}


@end
