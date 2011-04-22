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
#import "Config.h"
#import "AbstractCocos2DAppDelegate.h"
#import "Remove.h"
#import "MenuItemSymbolic.h"
#import "GLUtils.h"


@interface ShadeLayer ()

- (void)_back:(CCNode *)sender;
- (void)_next:(CCNode *)sender;

@property (nonatomic, readwrite, assign) BOOL                                           pushed;
@property (readwrite, retain) CCMenu                                                    *backMenu;
@property (readwrite, retain) CCMenu                                                    *nextMenu;
@property (readwrite, retain) NSInvocation                                              *backInvocation;
@property (readwrite, retain) NSInvocation                                              *nextInvocation;

@end


@implementation ShadeLayer

@synthesize pushed = _pushed;
@synthesize fadeNextEntry = _fadeNextEntry;
@synthesize backButton = _backButton, nextButton = _nextButton;
@synthesize backMenu = _backMenu, nextMenu = _nextMenu;
@synthesize backInvocation = _backInvocation, nextInvocation = _nextInvocation;
@synthesize background = _background;
@synthesize backgroundOffset = _backgroundOffset;



-(id) init {

    if(!(self = [super init]))
        return self;
    
    self.pushed                     = NO;
    self.fadeNextEntry              = YES;
    self.backgroundOffset           = CGPointZero;
    
    ccColor4B shadeColor            = ccc4l([[Config get].shadeColor longValue]);
    self.opacity                    = shadeColor.a;
    self.color                      = ccc4to3(shadeColor);

    [self setBackButton:nil];
    [self setNextButton:nil];
    self.backMenu = [CCMenu menuWithItems:self.backButton, nil];
    self.backMenu.position = ccp([[Config get].fontSize unsignedIntValue] * 1.5f,
                            [[Config get].fontSize unsignedIntValue] * 1.5f);
    [self.backMenu alignItemsHorizontally];
    
    self.nextMenu = [CCMenu menuWithItems:self.nextButton, nil];
    self.nextMenu.position = ccp(self.contentSize.width - [[Config get].fontSize unsignedIntValue] * 1.5f,
                            [[Config get].fontSize unsignedIntValue] * 1.5f);
    [self.nextMenu alignItemsHorizontally];

    [self addChild:self.backMenu z:9];
    [self addChild:self.nextMenu z:9];

    [self setBackButtonTarget:self selector:@selector(back)];
    [self setNextButtonTarget:nil selector:nil];

    return self;
}


- (void)setBackButton:(CCMenuItem *)aBackButton {
    
    if (self.backButton)
        [self.backMenu removeChild:self.backButton cleanup:YES];
    
    [_backButton release];
    _backButton = [aBackButton retain];
    if (!self.backButton) {
        _backButton = [[MenuItemSymbolic itemFromString:@"   ◃   " target:self selector:@selector(_back:)] retain];
        self.backMenu.visible = self.backInvocation != nil;
    } else
        self.backMenu.visible = YES;
    
    [self.backMenu addChild:self.backButton];
    [self.backMenu alignItemsHorizontally];
}


- (void) setBackButtonTarget:(id)target selector:(SEL)selector {

    if (target) {
        self.backInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [self.backInvocation setTarget:target];
        [self.backInvocation setSelector:selector];
    } else
        self.backInvocation = nil;
    
    self.backMenu.visible = self.backInvocation != nil;
}


- (void)setNextButton:(CCMenuItem *)aNextButton {
    
    if (self.nextButton)
        [self.nextMenu removeChild:self.nextButton cleanup:YES];

    [_nextButton release];
    _nextButton = [aNextButton retain];
    if (!self.nextButton) {
        _nextButton = [[MenuItemSymbolic itemFromString:@"   ▹   " target:self selector:@selector(_next:)] retain];
        self.nextMenu.visible = self.backInvocation != nil;
    } else
        self.nextMenu.visible = YES;
    
    [self.nextMenu addChild:self.nextButton];
    [self.nextMenu alignItemsHorizontally];
}


- (void) setNextButtonTarget:(id)target selector:(SEL)selector {
    
    if (target) {
        self.nextInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [self.nextInvocation setTarget:target];
        [self.nextInvocation setSelector:selector];
    } else
        self.nextInvocation = nil;
    
    self.nextMenu.visible = self.nextInvocation != nil;
}


- (void)_back:(CCNode *)sender {
    
    [self.backInvocation invoke];
}


- (void)_next:(CCNode *)sender {
    
    [self.nextInvocation invoke];
}


- (void)back {
    
    [[AudioController get] clickEffect];
    [[AbstractCocos2DAppDelegate get] popLayer];
}


-(void) onEnter {
        
    [self setPosition:ccp((self.pushed? -1: 1) * self.contentSize.width, 0)];

    [self stopAllActions];

    [super onEnter];
    
    self.visible = YES;
    [self enterAction];
}

-(void) ready {
    
    // Override me.
}


-(void) dismissAsPush:(BOOL)isPushed {

    [self stopAllActions];
    
    self.pushed = isPushed;
    [self dismissAction];
}


- (void)enterAction {
    
    [self runAction:[CCSequence actions:
                     [CCEaseSineOut actionWithAction:
                      [CCMoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                                          position:CGPointZero]],
                     [CCCallFunc actionWithTarget:self selector:@selector(ready)],
                     nil]];
}


- (void)dismissAction {
    
    [self runAction:[CCSequence actions:
                     [CCEaseSineOut actionWithAction:
                      [CCMoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                                          position:ccp((self.pushed? -1: 1) * self.contentSize.width, 0)]],
                     [CCCallFunc actionWithTarget:self selector:@selector(gone)],
                     [Remove action],
                     nil]];
}


-(void) gone {
    
    // Override me.
}


- (void)setBackground:(CCNode *)aBackground {
    
    [self removeChild:self.background cleanup:YES];
    
    [_background release];
    _background = [aBackground retain];
    if (!self.background)
        return;
    
    [self addChild:self.background z:-1];
    
    // Automatically set correct position of texture nodes.
    if (CGPointEqualToPoint(self.background.position, CGPointZero) && [self.background isKindOfClass:[CCSprite class]])
        self.backgroundOffset = ccp(self.background.contentSize.width / 2, self.background.contentSize.height / 2);
}


- (void)setPosition:(CGPoint)newPosition {
    
    super.position      = newPosition;
    
    self.background.position = ccp(self.backgroundOffset.x - newPosition.x, self.backgroundOffset.y - newPosition.y);
    if ([self.background conformsToProtocol:@protocol(CCRGBAProtocol)] && self.fadeNextEntry)
        ((id<CCRGBAProtocol>)self.background).opacity  = 0xff * (1 - fabs(newPosition.x) / self.contentSize.width);
    
    if (CGPointEqualToPoint(newPosition, CGPointZero))
        self.fadeNextEntry   = YES;
}


- (void)dealloc {

    self.background = nil;
    self.backButton = nil;
    self.nextButton = nil;
    self.backMenu = nil;
    self.nextMenu = nil;
    self.backInvocation = nil;
    self.nextInvocation = nil;

    [super dealloc];
}

@end
