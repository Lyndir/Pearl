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
//  BarLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 05/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "BarLayer.h"
#import "Config.h"
#import "GLUtils.h"
#import "Remove.h"


@interface BarLayer ()

@property (readwrite, retain) CCMenuItemFont         *menuButton;
@property (readwrite, retain) CCMenu                 *menuMenu;
@property (readwrite, retain) CCLabelTTF                *messageLabel;

@property (readwrite, assign) long                 color;
@property (readwrite, assign) long                 renderColor;
@property (readwrite, assign) CGPoint               showPosition;

@property (nonatomic, readwrite, assign) BOOL                 dismissed;

@end


@implementation BarLayer

@synthesize menuButton = _menuButton;
@synthesize menuMenu = _menuMenu;
@synthesize messageLabel = _messageLabel;
@synthesize color = _color, renderColor = _renderColor;
@synthesize showPosition = _showPosition;
@synthesize dismissed = _dismissed;

+ (BarLayer *)barWithColor:(long)aColor position:(CGPoint)aShowPosition {
    
    return [[[self alloc] initWithColor:aColor position:aShowPosition] autorelease];
}

-(id) initWithColor:(long)aColor position:(CGPoint)aShowPosition {
    
    if(!(self = [super init]))
        return self;
    
    self.texture            = [[CCTextureCache sharedTextureCache] addImage:@"bar.png"];
    self.textureRect        = CGRectFromCGPointAndCGSize(CGPointZero,
                                                         CGSizeMake([CCDirector sharedDirector].winSize.width,
                                                                    self.texture.contentSize.height));
    ccTexParams texParams = { GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_CLAMP_TO_EDGE };
	[self.texture setTexParameters: &texParams];
    
    self.color              = aColor;
    self.renderColor        = aColor;
    self.showPosition       = ccpAdd(aShowPosition, ccp(self.contentSize.width / 2, self.contentSize.height / 2));
    self.dismissed          = YES;
    
    return self;
}


-(void) setButtonImage:(NSString *)aFile callback:(id)target :(SEL)selector {
    
    if(self.menuMenu) {
        [self removeChild:self.menuMenu cleanup:NO];
        self.menuMenu    = nil;
        self.menuButton  = nil;
    }
    
    if(!aFile)
        // No string means no button.
        return;
    
    self.menuButton          = [CCMenuItemImage itemFromNormalImage:aFile selectedImage:aFile
                                                             target:target selector:selector];
    self.menuMenu            = [CCMenu menuWithItems:self.menuButton, nil];
    self.menuMenu.position   = ccp(self.contentSize.width - self.menuButton.contentSize.width / 2, 16);
    
    
    [self.menuMenu alignItemsHorizontally];
    [self addChild:self.menuMenu];
}

-(void) message:(NSString *)msg isImportant:(BOOL)important {
    
    [self message:msg duration:0 isImportant:important];
}

-(void) message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important {
    
    if (self.messageLabel)
        [self removeChild:self.messageLabel cleanup:YES];
    
    CGFloat fontSize = [[Config get].smallFontSize intValue];
    self.messageLabel = [CCLabelTTF labelWithString:msg dimensions:self.contentSize alignment:UITextAlignmentCenter
                                           fontName:[Config get].fixedFontName fontSize:fontSize];
    
    if(important) {
        self.renderColor = 0x993333FF;
        [self.messageLabel setColor:ccc3(0xCC, 0x33, 0x33)];
    } else {
        self.renderColor = self.color;
        [self.messageLabel setColor:ccc3(0xFF, 0xFF, 0xFF)];
    }
    
    [self.messageLabel setPosition:ccp(self.contentSize.width / 2, fontSize / 2 + 2)];
    [self addChild:self.messageLabel];
    
    if(_duration)
        [self.messageLabel runAction:[CCSequence actions:
                                      [CCDelayTime actionWithDuration:_duration],
                                      [CCCallFunc actionWithTarget:self selector:@selector(dismissMessage)],
                                      nil]];
}

-(void) reveal {
    
    self.dismissed = NO;
    
    [self stopAllActions];
    
    if([self.messageLabel parent])
        [self.messageLabel removeFromParentAndCleanup:NO];
    
    self.position = self.hidePosition;
    [self runAction:[CCMoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                                        position:self.showPosition]];
}

-(void) dismissMessage {
    
    [self.messageLabel stopAllActions];
    [self removeChild:self.messageLabel cleanup:NO];
    
    self.renderColor = self.color;
}


-(void) dismiss {
    
    if(self.dismissed)
        // Already being dismissed.
        return;
    
    self.dismissed = YES;
    
    [self stopAllActions];
    
    self.position = self.showPosition;
    [self runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                                         position:self.hidePosition],
                     //[Remove action],
                     nil]];
}


-(CGPoint) hidePosition {
    
    return ccpAdd(self.showPosition, ccp(0, -self.contentSize.height));
}


-(void) draw {
    
    [super draw];
    
    CGPoint to = ccp(self.contentSizeInPixels.width, self.contentSizeInPixels.height);
    DrawLinesTo(ccp(0, to.y), &to, 1, ccc4(0xFF, 0xFF, 0xFF, 0xFF), 1);
}

-(void) dealloc {
    
    self.messageLabel = nil;
    self.menuButton = nil;
    self.menuMenu = nil;
    
    [super dealloc];
}

@end
