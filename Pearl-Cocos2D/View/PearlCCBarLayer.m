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
//  PearlCCBarLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 05/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCBarLayer.h"
#import "PearlUIUtils.h"

@interface PearlCCBarLayer ()

@property (readwrite, retain) CCMenuItemAtlasFont *menuButton;
@property (readwrite, retain) CCMenu              *menuMenu;
@property (readwrite, retain) CCLabelTTF          *messageLabel;

@property (readwrite, assign) NSUInteger textColor;
@property (readwrite, assign) NSUInteger renderColor;
@property (readwrite, assign) CGPoint    showPosition;

@property (nonatomic, readwrite, assign) BOOL dismissed;

@end


@implementation PearlCCBarLayer

@synthesize menuButton = _menuButton;
@synthesize menuMenu = _menuMenu;
@synthesize messageLabel = _messageLabel;
@synthesize textColor = _textColor, renderColor = _renderColor;
@synthesize showPosition = _showPosition;
@synthesize dismissed = _dismissed;

+ (instancetype)barWithColor:(NSUInteger)aColor position:(CGPoint)aShowPosition {

    return [[self alloc] initWithColor:aColor position:aShowPosition];
}

- (id)initWithColor:(NSUInteger)aColor position:(CGPoint)aShowPosition {

    if (!(self = [super initWithFile:@"bar.png"]))
        return self;

    [self setTextureRect:CGRectFromOriginWithSize(CGPointZero, CGSizeMake([CCDirector sharedDirector].winSize.width,
                                                                          self.texture.contentSize.height))];

    ccTexParams texParams = {GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_CLAMP_TO_EDGE};
    [self.texture setTexParameters:&texParams];

    self.textColor    = aColor;
    self.renderColor  = aColor;
    self.showPosition = ccpAdd(aShowPosition, ccp(self.contentSize.width / 2, self.contentSize.height / 2));
    self.dismissed    = YES;
    [self reveal];

    return self;
}


- (void)setButtonTitle:(NSString *)aTitle callback:(id)target :(SEL)selector {

    if (self.menuMenu) {
        [self removeChild:self.menuMenu cleanup:NO];
        self.menuMenu   = nil;
        self.menuButton = nil;
    }

    if (!aTitle)
     // No string means no button.
        return;

    NSString *oldFontName = [CCMenuItemFont fontName];
    NSUInteger oldFontSize = [CCMenuItemFont fontSize];
    [CCMenuItemFont setFontName:@"Bonk"];
    [CCMenuItemFont setFontSize:[[PearlConfig get].smallFontSize unsignedIntValue]];
    self.menuButton = [CCMenuItemFont itemWithString:aTitle target:target selector:selector];
    [CCMenuItemFont setFontName:oldFontName];
    [CCMenuItemFont setFontSize:oldFontSize];

    self.menuMenu          = [CCMenu menuWithItems:self.menuButton, nil];
    self.menuMenu.position = ccp(self.contentSize.width - self.menuButton.contentSize.width / 2 - 5, self.contentSize.height / 2);

    [self.menuMenu alignItemsHorizontally];
    [self addChild:self.menuMenu];
}

- (void)message:(NSString *)msg isImportant:(BOOL)important {

    [self message:msg duration:0 isImportant:important];
}

- (void)message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important {

    if (self.messageLabel)
        [self removeChild:self.messageLabel cleanup:YES];

    CGFloat fontSize = [[PearlConfig get].smallFontSize floatValue];
    self.messageLabel = [CCLabelTTF labelWithString:msg fontName:[PearlConfig get].fixedFontName fontSize:fontSize
                                         dimensions:self.contentSize hAlignment:kCCTextAlignmentCenter];

    if (important) {
        self.renderColor = 0x993333FF;
        [self.messageLabel setColor:ccc3(0xCC, 0x33, 0x33)];
    } else {
        self.renderColor = self.textColor;
        [self.messageLabel setColor:ccc3(0xFF, 0xFF, 0xFF)];
    }

    [self.messageLabel setPosition:ccp(self.contentSize.width / 2, fontSize / 2 + 2)];
    [self addChild:self.messageLabel];

    if (_duration)
        [self.messageLabel runAction:[CCSequence actions:
                                                  [CCDelayTime actionWithDuration:_duration],
                                                  [CCCallFunc actionWithTarget:self selector:@selector(dismissMessage)],
                                                  nil]];
}

- (void)reveal {

    self.dismissed = NO;

    [self stopAllActions];

    self.position = self.hidePosition;
    [self runAction:[CCSpawn actions:
                              [CCMoveTo actionWithDuration:[[PearlConfig get].transitionDuration floatValue]
                                        position:self.showPosition],
                              [CCFadeIn actionWithDuration:[[PearlConfig get].transitionDuration floatValue]],
                              nil]];
}

- (void)dismissMessage {

    [self.messageLabel stopAllActions];
    [self.messageLabel removeFromParentAndCleanup:NO];

    self.renderColor = self.textColor;
}


- (void)dismiss {

    if (self.dismissed)
     // Already being dismissed.
        return;

    self.dismissed = YES;

    [self stopAllActions];

    self.position = self.showPosition;
    [self runAction:[CCSpawn actions:
                              [CCMoveTo actionWithDuration:[[PearlConfig get].transitionDuration floatValue]
                                        position:self.hidePosition],
                              [CCFadeOut actionWithDuration:[[PearlConfig get].transitionDuration floatValue]],
                              nil]];
}

- (void)setOpacity:(GLubyte)anOpacity {

    [super setOpacity:anOpacity];

    [self.menuMenu setOpacity:anOpacity];
    [self.menuButton setOpacity:anOpacity];
    [self.messageLabel setOpacity:anOpacity];
}


- (CGPoint)hidePosition {

    return ccpAdd(self.showPosition, ccp(0, -self.contentSize.height));
}


- (void)draw {

    [super draw];

    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"PearlCCBarLayer - draw");
    CC_NODE_DRAW_SETUP();

    ccDrawColor4B(0xff, 0xff, 0xff, self.opacity);
    ccDrawLine(ccp(0, self.contentSize.height), CGPointFromCGSize(self.contentSize));

    CHECK_GL_ERROR_DEBUG();
    CC_INCREMENT_GL_DRAWS(1);
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"PearlCCBarLayer - draw");
}

@end
