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
//  iLibs
//
//  Created by Maarten Billemont on 10/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "HUDLayer.h"
#import "AbstractAppDelegate.h"

@implementation HUDLayer


-(id) init {
    
    if(!(self = [super initWithColor:0xFFFFFFFF position:CGPointZero]))
        return self;

    [super setButtonImage:@"menu.png"
                 callback:self :@selector(menuButton:)];
    messageBar          = [[BarLayer alloc] initWithColor:0xAAAAAAFF position:ccp(0, self.contentSize.height)];
    
    // Score.
    scoreSprite = [[Sprite alloc] initWithFile:@"score.png"];
    scoreCount = [[LabelAtlas alloc] initWithString:@""
                                        charMapFile:@"bonk.png" itemWidth:13 itemHeight:26 startCharMap:' '];
    [scoreSprite setPosition:ccp(self.contentSize.width / 2, self.contentSize.height / 2)];
    [scoreCount setPosition:ccp(90, 0)];
    [self addChild:scoreSprite];
    [self addChild:scoreCount];
    
    return self;
}


-(void) updateHudWithScore:(int)score {
    
    [scoreCount setString:[NSString stringWithFormat:@"%04d", [[Config get].score intValue]]];
    [scoreCount setVisible:YES];
    [scoreSprite setVisible:YES];
    
    if(score) {
        ccColor3B scoreColor;
        if(score > 0)
            scoreColor = ccc3(0x99, 0xFF, 0x99);
        else if(score < 0)
            scoreColor = ccc3(0xFF, 0x99, 0x99);
        
        [scoreCount runAction:[Sequence actions:
                                    [TintTo actionWithDuration:0.5f red:scoreColor.r green:scoreColor.b blue:scoreColor.b],
                                    [TintTo actionWithDuration:0.5f red:0xFF green:0xFF blue:0xFF],
                                    nil]];
    }
}


-(void) message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important {
    // Proxy to messageBar
    
    if([messageBar parent] && [messageBar dismissed])
        [self removeChild:messageBar cleanup:YES];

    if(![messageBar parent])
        [self addChild:messageBar z:-1];
    
    [messageBar message:msg duration:0 isImportant:important];
    
    if(_duration)
        [self runAction:[Sequence actions:
                         [DelayTime actionWithDuration:_duration],
                         [CallFunc actionWithTarget:self selector:@selector(dismissMessage)],
                         nil]];
}


-(void) dismissMessage {
    // Proxy to messageBar

    [messageBar dismiss];
    [messageBar setButtonImage:nil callback:nil :nil];
    
    if(![menuMenu parent])
        [self addChild:menuMenu];
}


-(void) setButtonImage:(NSString *)aFile callback:(id)target :(SEL)selector {
    // Proxy to messageBar

    [messageBar setButtonImage:aFile callback:target :selector];
    [self removeChild:menuMenu cleanup:NO];
}


-(void) onEnter {

    [super onEnter];
    
    if([messageBar parent])
        [self removeChild:messageBar cleanup:YES];
    
    [self updateHudWithScore:0];
}


-(void) menuButton: (id) caller {
    
    [[AudioController get] clickEffect];
    [[AbstractAppDelegate get] hudMenuPressed];
}


-(BOOL) hitsHud: (CGPoint)pos {
    
    return  pos.x >= self.position.x         &&
            pos.y >= self.position.y         &&
            pos.x <= self.position.x + self.contentSize.width &&
            pos.y <= self.position.y + self.contentSize.height;
}


-(void) dealloc {
    
    [scoreSprite release];
    scoreSprite = nil;
    
    [scoreCount release];
    scoreCount = nil;
    
    [super dealloc];
}


@end
