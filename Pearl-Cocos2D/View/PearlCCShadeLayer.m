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
//  PearlCCShadeLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 26/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCShadeLayer.h"
#import "PearlGLUtils.h"
#import "PearlCCMenuItemSymbolic.h"
#import "PearlCocos2DAppDelegate.h"
#import "PearlCCRemove.h"

@interface PearlCCShadeLayer ()

- (void)_back:(CCNode *)sender;
- (void)_next:(CCNode *)sender;

@property (nonatomic, readwrite, assign) BOOL pushed;
@property (readwrite, retain) CCMenu       *backMenu;
@property (readwrite, retain) CCMenu       *nextMenu;
@property (readwrite, retain) NSInvocation *backInvocation;
@property (readwrite, retain) NSInvocation *nextInvocation;

@end


@implementation PearlCCShadeLayer

@synthesize pushed = _pushed;
@synthesize fadeNextEntry = _fadeNextEntry;
@synthesize backButton = _backButton, nextButton = _nextButton;
@synthesize defaultBackButton = _defaultBackButton, defaultNextButton = _defaultNextButton;
@synthesize backMenu = _backMenu, nextMenu = _nextMenu;
@synthesize backInvocation = _backInvocation, nextInvocation = _nextInvocation;
@synthesize background = _background;
@synthesize backgroundOffset = _backgroundOffset;


- (id)init {

    if (!(self = [super init]))
        return self;

    self.pushed           = NO;
    self.fadeNextEntry    = YES;
    self.backgroundOffset = CGPointZero;

    ccColor4B shadeColor = ccc4l([[PearlConfig get].shadeColor unsignedLongValue]);
    self.opacity = shadeColor.a;
    self.color   = ccc4to3(shadeColor);

    self.defaultBackButton = [PearlCCMenuItemSymbolic itemWithString:@"   ◃   " target:self selector:@selector(_back:)];
    self.defaultNextButton = [PearlCCMenuItemSymbolic itemWithString:@"   ▹   " target:self selector:@selector(_next:)];

    [self setBackButton:nil];
    [self setNextButton:nil];
    self.backMenu          = [CCMenu menuWithItems:self.backButton, nil];
    self.backMenu.position = ccp([[PearlConfig get].fontSize unsignedIntValue] * 1.5f,
    [[PearlConfig get].fontSize unsignedIntValue]);
    [self.backMenu alignItemsHorizontally];

    self.nextMenu          = [CCMenu menuWithItems:self.nextButton, nil];
    self.nextMenu.position = ccp(self.contentSize.width - [[PearlConfig get].fontSize unsignedIntValue] * 1.5f,
    [[PearlConfig get].fontSize unsignedIntValue]);
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

    _backButton = aBackButton;
    if (!self.backButton) {
        _backButton = self.defaultBackButton;
        self.backMenu.visible = self.backInvocation != nil;
    } else
        self.backMenu.visible = YES;

    [self.backMenu addChild:self.backButton];
    [self.backMenu alignItemsHorizontally];
}


- (void)setBackButtonTarget:(id)target selector:(SEL)selector {

    if (target) {
        self.backInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [self.backInvocation setTarget:target];
        [self.backInvocation setSelector:selector];
    } else
        self.backInvocation = nil;

    if (self.backButton == self.defaultBackButton)
        self.backMenu.visible = self.backInvocation != nil;

    self.backMenu.visible = self.backInvocation != nil;
}


- (void)setNextButton:(CCMenuItem *)aNextButton {

    if (self.nextButton)
        [self.nextMenu removeChild:self.nextButton cleanup:YES];

    _nextButton = aNextButton;
    if (!self.nextButton) {
        _nextButton = self.defaultNextButton;
        self.nextMenu.visible = self.nextInvocation != nil;
    } else
        self.nextMenu.visible = YES;

    [self.nextMenu addChild:self.nextButton];
    [self.nextMenu alignItemsHorizontally];
}


- (void)setNextButtonTarget:(id)target selector:(SEL)selector {

    if (target) {
        self.nextInvocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
        [self.nextInvocation setTarget:target];
        [self.nextInvocation setSelector:selector];
    } else
        self.nextInvocation = nil;

    if (self.nextButton == self.defaultNextButton)
        self.nextMenu.visible = self.nextInvocation != nil;

    self.nextMenu.visible = self.nextInvocation != nil;
}


- (void)_back:(CCNode *)sender {

    [self.backInvocation invoke];
}


- (void)_next:(CCNode *)sender {

    [self.nextInvocation invoke];
}


- (void)back {

#ifdef PEARL_MEDIA
    [[PearlAudioController get] clickEffect];
#endif
    [[PearlCocos2DAppDelegate get] popLayer];
}


- (void)onEnter {

    [self setPosition:ccp((self.pushed? -1: 1) * self.contentSize.width, 0)];

    [self stopAllActions];

    [super onEnter];

    self.visible = YES;
    [self enterAction];
}

- (void)ready {

    // Override me.
}


- (void)dismissAsPush:(BOOL)isPushed {

    [self stopAllActions];

    self.pushed = isPushed;
    [self dismissAction];
}


- (void)enterAction {

    [self runAction:[CCSequence actions:
                                 [CCEaseSineOut actionWithAction:
                                                 [CCMoveTo actionWithDuration:[[PearlConfig get].transitionDuration floatValue]
                                                           position:CGPointZero]],
                                 [CCCallFunc actionWithTarget:self selector:@selector(ready)],
                                 nil]];
}


- (void)dismissAction {

    [self runAction:[CCSequence actions:
                                 [CCEaseSineOut actionWithAction:
                                                 [CCMoveTo actionWithDuration:[[PearlConfig get].transitionDuration floatValue]
                                                           position:ccp((self.pushed? -1: 1) * self.contentSize.width, 0)]],
                                 [CCCallFunc actionWithTarget:self selector:@selector(gone)],
                                 [PearlCCRemove action],
                                 nil]];
}


- (void)gone {

    // Override me.
}


- (void)setBackground:(CCNode *)aBackground {

    [self removeChild:self.background cleanup:YES];

    _background = aBackground;
    if (!self.background)
        return;

    [self addChild:self.background z:-1];

    // Automatically set correct position of texture nodes.
    if (CGPointEqualToPoint(self.background.position, CGPointZero) && [self.background isKindOfClass:[CCSprite class]])
        self.backgroundOffset = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
}


- (void)setPosition:(CGPoint)newPosition {

    super.position = newPosition;

    self.background.position = ccp(self.backgroundOffset.x - newPosition.x, self.backgroundOffset.y - newPosition.y);
    if ([self.background conformsToProtocol:@protocol(CCRGBAProtocol)] && self.fadeNextEntry)
        [((id<CCRGBAProtocol>)self.background) setOpacity:(GLubyte)(0xff * (1 - fabs(newPosition.x) / self.contentSize.width))];

    if (CGPointEqualToPoint(newPosition, CGPointZero))
        self.fadeNextEntry = YES;
}

@end
