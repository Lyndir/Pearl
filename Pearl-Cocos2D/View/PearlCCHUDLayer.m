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
//  PearlCCHUDLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 10/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCHUDLayer.h"
#ifdef PEARL_MEDIA
#import "PearlAudioController.h"
#endif
#import "PearlCocos2DAppDelegate.h"

@interface PearlCCBarLayer ()

@property (nonatomic, readwrite, retain) CCMenu *menuMenu;

@end

@interface PearlCCHUDLayer ()

- (void)menuButton:(id)caller;

@property (nonatomic, readwrite, retain) CCLabelAtlas    *scoreSprite;
@property (nonatomic, readwrite, retain) CCLabelAtlas    *scoreCount;
@property (nonatomic, readwrite, retain) PearlCCBarLayer *messageBar;

@end

@implementation PearlCCHUDLayer

@synthesize scoreSprite = _scoreSprite;
@synthesize scoreCount = _scoreCount;
@synthesize messageBar = _messageBar;


- (id)init {

    if (!(self = [super initWithColor:0xFFFFFFFF position:CGPointZero]))
        return self;

    [super setButtonTitle:@"Menu" callback:self :@selector(menuButton:)];
    self.messageBar = [PearlCCBarLayer barWithColor:0xAAAAAAFF position:ccp(0, self.contentSize.height)];
    [self addChild:self.messageBar z:-1];
    [self.messageBar dismiss];

    // Score.
    self.scoreSprite          = [CCLabelTTF labelWithString:@"Score:" fontName:@"Bonk"
                                                   fontSize:[[PearlConfig get].smallFontSize floatValue]];
    self.scoreCount           = [CCLabelTTF labelWithString:@"0000" fontName:@"Bonk" fontSize:[[PearlConfig get].smallFontSize floatValue]];
    self.scoreSprite.position = ccp(5 + self.scoreSprite.contentSize.width / 2, self.contentSize.height / 2);
    [self.scoreCount setPosition:ccp(5 + self.scoreSprite.contentSize.width + 5 + self.scoreCount.contentSize.width
     / 2, self.contentSize.height / 2)];
    [self addChild:self.scoreSprite];
    [self addChild:self.scoreCount];

    return self;
}


- (int64_t)score {

    return 0;
}


- (void)reset {

    [self.scoreCount setString:[NSString stringWithFormat:@"%04lld", [self score]]];
}

- (void)highlightGood:(BOOL)wasGood {

    [self reset];

    ccColor3B scoreColor;
    if (wasGood)
        scoreColor = ccc3(0x99, 0xFF, 0x99);
    else
        scoreColor = ccc3(0xFF, 0x99, 0x99);

    [self.scoreCount runAction:[CCSequence actions:
                                            [CCTintTo actionWithDuration:0.5f red:scoreColor.r green:scoreColor.b blue:scoreColor.b],
                                            [CCTintTo actionWithDuration:0.5f red:0xFF green:0xFF blue:0xFF],
                                            nil]];
}


- (void)message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important {
    // Proxy to messageBar

    [self.messageBar message:msg duration:0 isImportant:important];
    [self.messageBar reveal];

    if (_duration)
        [self runAction:[CCSequence actions:
                                     [CCDelayTime actionWithDuration:_duration],
                                     [CCCallFunc actionWithTarget:self selector:@selector(dismissMessage)],
                                     nil]];
}


- (void)dismissMessage {
    // Proxy to messageBar

    [self.messageBar dismiss];
    [self.messageBar setButtonTitle:nil callback:nil :nil];

    if (self.menuMenu && ![self.menuMenu parent])
        [self addChild:self.menuMenu];
}


- (void)setButtonTitle:(NSString *)aTitle callback:(id)target :(SEL)selector {
    // Proxy to messageBar

    [self.messageBar setButtonTitle:aTitle callback:target :selector];
    [self removeChild:self.menuMenu cleanup:NO];
}


- (void)onEnter {

    [super onEnter];

    [self reset];
}

- (void)menuButton:(id)caller {

    if (self.visible) {
#ifdef PEARL_MEDIA
        [[PearlAudioController get] clickEffect];
#endif
        [[PearlCocos2DAppDelegate get] hudMenuPressed];
    }
}


- (BOOL)hitsHud:(CGPoint)pos {

    return self.visible &&
     pos.x >= self.position.x &&
     pos.y >= self.position.y &&
     pos.x <= self.position.x + self.contentSize.width &&
     pos.y <= self.position.y + self.contentSize.height;
}


@end
