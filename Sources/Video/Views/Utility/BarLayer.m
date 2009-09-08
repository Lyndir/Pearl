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
//  iLibs
//
//  Created by Maarten Billemont on 05/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "BarLayer.h"
#import "Remove.h"


@implementation BarLayer

@synthesize dismissed;


-(id) initWithColor:(long)aColor position:(CGPoint)_showPosition {
    
    if(!(self = [super initWithFile:@"bar.png"]))
        return self;

    color           = aColor;
    renderColor     = aColor;
    showPosition    = ccpAdd(_showPosition, ccp(self.contentSize.width / 2, self.contentSize.height / 2));
    dismissed       = YES;

    menuButton      = nil;
    menuMenu        = nil;
    
    return self;
}


-(void) setButtonImage:(NSString *)aFile callback:(id)target :(SEL)selector {

    if(menuMenu) {
        [self removeChild:menuMenu cleanup:NO];
        [menuMenu release];
        [menuButton release];
        menuMenu    = nil;
        menuButton  = nil;
    }
    
    if(!aFile)
        // No string means no button.
        return;
        
    menuButton          = [[MenuItemImage itemFromNormalImage:aFile selectedImage:aFile
                                                       target:target selector:selector] retain];
    menuMenu            = [[Menu menuWithItems:menuButton, nil] retain];
    menuMenu.position   = ccp(self.contentSize.width - menuButton.contentSize.width / 2, 16);

    
    [menuMenu alignItemsHorizontally];
    [self addChild:menuMenu];
}


-(void) onEnter {
    
    dismissed = NO;
    
    [super onEnter];
    
    [self stopAllActions];
    
    if([messageLabel parent])
        [self removeChild:messageLabel cleanup:NO];
    
    self.position = self.hidePosition;
    [self runAction:[MoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                               position:showPosition]];
}


-(void) message:(NSString *)msg isImportant:(BOOL)important {
    
    [self message:msg duration:0 isImportant:important];
}


-(void) message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important {
    
    if (messageLabel) {
        [self removeChild:messageLabel cleanup:YES];
        [messageLabel release];
    }
    
    CGFloat fontSize = [[Config get].smallFontSize intValue];
    messageLabel = [[Label alloc] initWithString:msg dimensions:self.contentSize alignment:UITextAlignmentCenter
                                        fontName:[Config get].fixedFontName fontSize:fontSize];

    if(important) {
        renderColor = 0x993333FF;
        [messageLabel setColor:ccc3(0xCC, 0x33, 0x33)];
    } else {
        renderColor = color;
        [messageLabel setColor:ccc3(0xFF, 0xFF, 0xFF)];
    }
    
    [messageLabel setPosition:ccp(self.contentSize.width / 2, fontSize / 2 + 2)];
    [self addChild:messageLabel];
    
    if(_duration)
        [messageLabel runAction:[Sequence actions:
                                 [DelayTime actionWithDuration:_duration],
                                 [CallFunc actionWithTarget:self selector:@selector(dismissMessage)],
                                 nil]];
}


-(void) dismissMessage {
    
    [messageLabel stopAllActions];
    [self removeChild:messageLabel cleanup:NO];
    
    renderColor = color;
}


-(void) dismiss {
    
    if(dismissed)
        // Already being dismissed.
        return;
    
    dismissed = YES;
    
    [self stopAllActions];
    
    self.position = showPosition;
    [self runAction:[Sequence actions:
              [MoveTo actionWithDuration:[[Config get].transitionDuration floatValue]
                                position:self.hidePosition],
              [Remove action],
              nil]];
}


-(CGPoint) hidePosition {
    
    return ccpAdd(showPosition, ccp(0, -self.contentSize.height));
}


-(void) draw {

    [super draw];
    
    CGPoint to = ccp(self.contentSize.width, self.contentSize.height);
    DrawLinesTo(ccp(0, self.contentSize.height), &to, 1, ccc4(0xFF, 0xFF, 0xFF, 0xFF), 1);
}

-(void) dealloc {
    
    [messageLabel release];
    messageLabel = nil;
    
    [menuButton release];
    menuButton = nil;
    
    [menuMenu release];
    menuMenu = nil;
    
    [super dealloc];
}

@end
