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
//  HUDLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 10/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"
#import "BarLayer.h"


@interface HUDLayer : BarLayer {

    CCSprite                                            *_scoreSprite;
    CCLabelAtlas                                        *_scoreCount;
    BarLayer                                            *_messageBar;
}

@property (nonatomic, readonly, retain) CCSprite        *scoreSprite;
@property (nonatomic, readonly, retain) CCLabelAtlas    *scoreCount;
@property (nonatomic, readonly, retain) BarLayer        *messageBar;

-(void) updateHudWasGood:(BOOL)wasGood;
-(void) updateHudWithNewScore:(int)newScore wasGood:(BOOL)wasGood;
-(BOOL) hitsHud: (CGPoint)pos;

@end
