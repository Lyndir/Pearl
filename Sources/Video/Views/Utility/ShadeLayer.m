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


@implementation ShadeLayer


-(id) init {

    if(!(self = [super init]))
        return self;
    
    pushed = NO;
    
    color = ccc([[Config get].shadeColor longValue]);
    
    NSUInteger oldFontSize = [MenuItemFont fontSize];
    [MenuItemFont setFontSize:[[Config get].largeFontSize unsignedIntValue]];
    MenuItem *back     = [MenuItemFont itemFromString:@"   <   "
                                               target:self
                                             selector:@selector(back:)];
    [MenuItemFont setFontSize:oldFontSize];
    
    backMenu = [[Menu menuWithItems:back, nil] retain];
    [backMenu setPosition:ccp([[Config get].fontSize unsignedIntValue],
                              [[Config get].fontSize unsignedIntValue])];
    [backMenu alignItemsHorizontally];
    [self addChild:backMenu];
    
    return self;
}


- (void)back:(CocosNode *)sender {
    
    [[AbstractAppDelegate get] popLayer];
}


-(void) onEnter {
        
    [self setPosition:ccp((pushed? -1: 1) * self.contentSize.width, 0)];

    [self stopAllActions];

    backMenu.visible = ![[AbstractAppDelegate get] isLastLayerShowing];
    
    [super onEnter];
    
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


@end
