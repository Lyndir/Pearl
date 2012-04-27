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
