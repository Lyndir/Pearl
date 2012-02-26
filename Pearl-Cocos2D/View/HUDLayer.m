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
//  HUDLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 10/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "HUDLayer.h"
#ifdef PEARL_MEDIA
#import "PearlAudioController.h"
#endif
#import "AbstractCocos2DAppDelegate.h"

@interface BarLayer ()

@property (nonatomic, readwrite, retain) CCMenu                 *menuMenu;

@end

@interface HUDLayer ()

- (void) menuButton:(id) caller;

@property (nonatomic, readwrite, retain) CCSprite               *scoreSprite;
@property (nonatomic, readwrite, retain) CCLabelAtlas           *scoreCount;
@property (nonatomic, readwrite, retain) BarLayer               *messageBar;

@end

@implementation HUDLayer

@synthesize scoreSprite = _scoreSprite;
@synthesize scoreCount = _scoreCount;
@synthesize messageBar = _messageBar;


-(id) init {
    
    if(!(self = [super initWithColor:0xFFFFFFFF position:CGPointZero]))
        return self;

    [super setButtonImage:@"menu.png"
                 callback:self :@selector(menuButton:)];
    self.messageBar = [BarLayer barWithColor:0xAAAAAAFF position:ccp(0, self.contentSize.height)];
    [self addChild:self.messageBar z:-1];
    [self.messageBar dismiss];
    
    // Score.
    self.scoreSprite = [CCSprite spriteWithFile:@"score.png"];
    self.scoreCount = [CCLabelAtlas labelWithString:@""
                                        charMapFile:@"bonk.png" itemWidth:13 itemHeight:26 startCharMap:' '];
    self.scoreSprite.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
    [self.scoreCount setPosition:ccp(90, 0)];
    [self addChild:self.scoreSprite];
    [self addChild:self.scoreCount];
    
    return self;
}


- (int64_t)score {
    
    return 0;
}


- (void)reset {
    
    [self.scoreCount setString:[NSString stringWithFormat:@"%04d", [self score]]];
}

- (void)highlightGood:(BOOL)wasGood {
    
    [self reset];
    
    ccColor3B scoreColor;
    if(wasGood)
        scoreColor = ccc3(0x99, 0xFF, 0x99);
    else
        scoreColor = ccc3(0xFF, 0x99, 0x99);
    
    [self.scoreCount runAction:[CCSequence actions:
                                [CCTintTo actionWithDuration:0.5f red:scoreColor.r green:scoreColor.b blue:scoreColor.b],
                                [CCTintTo actionWithDuration:0.5f red:0xFF green:0xFF blue:0xFF],
                                nil]];
}


-(void) message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important {
    // Proxy to messageBar
    
    [self.messageBar message:msg duration:0 isImportant:important];
    [self.messageBar reveal];
    
    if(_duration)
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:_duration],
                         [CCCallFunc actionWithTarget:self selector:@selector(dismissMessage)],
                         nil]];
}


-(void) dismissMessage {
    // Proxy to messageBar

    [self.messageBar dismiss];
    [self.messageBar setButtonImage:nil callback:nil :nil];
    
    if(![self.menuMenu parent])
        [self addChild:self.menuMenu];
}


-(void) setButtonImage:(NSString *)aFile callback:(id)target :(SEL)selector {
    // Proxy to messageBar

    [self.messageBar setButtonImage:aFile callback:target :selector];
    [self removeChild:self.menuMenu cleanup:NO];
}


-(void) onEnter {

    [super onEnter];
    
    [self reset];
}

-(void) menuButton: (id) caller {

    if (self.visible) {
#ifdef PEARL_MEDIA
        [[PearlAudioController get] clickEffect];
#endif
        [[AbstractCocos2DAppDelegate get] hudMenuPressed];
    }
}


-(BOOL) hitsHud: (CGPoint)pos {
    
    return  self.visible                     &&
            pos.x >= self.position.x         &&
            pos.y >= self.position.y         &&
            pos.x <= self.position.x + self.contentSize.width &&
            pos.y <= self.position.y + self.contentSize.height;
}


-(void) dealloc {
    
    self.scoreSprite = nil;
    self.scoreCount = nil;
    
    self.menuMenu = nil;
    self.messageBar = nil;

    [super dealloc];
}


@end
