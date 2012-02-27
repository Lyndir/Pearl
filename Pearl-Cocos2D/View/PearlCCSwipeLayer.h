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
//  PearlCCSwipeLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 15/02/09.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCSwipeLayer : CCLayer {

    NSInvocation        *_invocation;

    CCActionInterval    *_swipeAction;
    CGPoint             _swipeFrom;
    CGPoint             _swipeTo;
    CGPoint             _swipeStart;
    BOOL                _swipeForward;
    BOOL                _swiped;
}

+(id) nodeWithTarget:(id)t selector:(SEL)s;

-(id) initWithTarget:(id)t selector:(SEL)s;

-(void) setSwipeAreaFrom:(CGPoint)f to:(CGPoint)t;
-(void) setTarget:(id)t selector:(SEL)s;
-(void) swipeDone:(id)sender;

@end
