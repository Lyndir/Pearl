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
//  PearlCCSwipeLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 15/02/09.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCSwipeLayer.h"
#import "PearlConfig.h"

#define SwipeMinHorizontal 50
#define SwipeMaxVertical 100


@interface PearlCCSwipeLayer ()

@property (readwrite, retain) NSInvocation     *invocation;

@property (readwrite, retain) CCActionInterval   *swipeAction;
@property (readwrite, assign) CGPoint           swipeFrom;
@property (readwrite, assign) CGPoint           swipeTo;
@property (readwrite, assign) CGPoint           swipeStart;
@property (readwrite, assign) BOOL             swipeForward;
@property (readwrite, assign) BOOL             swiped;

@end


@implementation PearlCCSwipeLayer

@synthesize invocation = _invocation;
@synthesize swipeAction = _swipeAction;
@synthesize swipeFrom = _swipeFrom;
@synthesize swipeTo = _swipeTo;
@synthesize swipeStart = _swipeStart;
@synthesize swipeForward = _swipeForward;
@synthesize swiped = _swiped;


+(id) nodeWithTarget:(id)t selector:(SEL)s {
    
    return [[PearlCCSwipeLayer alloc] initWithTarget:t selector:s];
}


-(id) initWithTarget:(id)t selector:(SEL)s {
    
    if(!(self = [super init]))
        return self;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    self.swiped          = NO;
    self.swipeStart      = ccp(-1, -1);
    self.swipeFrom       = CGPointZero;
    self.swipeTo         = ccp(winSize.width, winSize.height);
    [self setTarget:t selector:s];

    self.isTouchEnabled  = YES;
    
    return self;
}


-(void) setSwipeAreaFrom:(CGPoint)f to:(CGPoint)t {
    
    self.swipeFrom = f;
    self.swipeTo = t;
}


- (void)setTarget:(id)t selector:(SEL)s {
    
    NSMethodSignature *sig = [[t class] instanceMethodSignatureForSelector:s];
    self.invocation = [NSInvocation invocationWithMethodSignature:sig];
    [self.invocation setTarget:t];
    [self.invocation setSelector:s];
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if([[event allTouches] count] != 1) {
        [self ccTouchesCancelled:touches withEvent:event];
        return;
    }

    if(self.position.x != 0 || self.position.y != 0)
        // Not in swipe ready position.
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    CGPoint swipePoint = ccp(point.y, point.x);
    
    if(swipePoint.x < self.swipeFrom.x || swipePoint.y < self.swipeFrom.y
        || swipePoint.x > self.swipeTo.x || swipePoint.y > self.swipeTo.y)
        // Lays outside swipeFrom - swipeTo box
        return;
    
    self.swipeStart  = swipePoint;
    self.swiped      = NO;
    
    return;
}


-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if([[event allTouches] count] != 1) {
        [self ccTouchesCancelled:touches withEvent:event];
        return;
    }

    if(self.swipeStart.x == -1 && self.swipeStart.y == -1)
        // Swipe hasn't yet begun.
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];

    CGPoint swipePoint = ccp(point.y, point.x);
    if(fabsf(self.swipeStart.x - swipePoint.x) > SwipeMinHorizontal
        && fabsf(self.swipeStart.y - swipePoint.y) < SwipeMaxVertical)
        self.swiped = YES;
    
    CGFloat swipeActionDuration = [[PearlConfig get].transitionDuration floatValue];
    if(self.swipeAction) {
        if(![self.swipeAction isDone])
            swipeActionDuration -= self.swipeAction.elapsed;
        [self stopAction:self.swipeAction];
    }
    [self runAction:self.swipeAction = [CCMoveTo actionWithDuration:swipeActionDuration
                                                         position:ccp(swipePoint.x - self.swipeStart.x, 0)]];
    
    return;
}


-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.swipeStart.x == -1 && self.swipeStart.y == -1)
        return;
    
    if(self.swipeAction) {
        [self stopAction:self.swipeAction];
        self.swipeAction = nil;
    }
    
    [self runAction:[CCMoveTo actionWithDuration:0.1f
                                      position:CGPointZero]];
    self.swipeStart = ccp(-1, -1);
    
    return;
}


-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(self.swipeStart.x == -1 && self.swipeStart.y == -1)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint swipePoint = ccp(point.y, point.x);
    CGFloat swipeDist = swipePoint.x - self.swipeStart.x;
    self.swipeForward = swipeDist < 0;
    CGPoint swipeTarget = ccp(winSize.width * (self.swipeForward? -1: 1), 0);
    
    if(self.swipeAction)
        [self stopAction:self.swipeAction];
    
    if(self.swiped)
        [self runAction:self.swipeAction = [CCSequence actionOne:[CCMoveTo actionWithDuration:[[PearlConfig get].transitionDuration floatValue]
                                                                                 position:swipeTarget]
                                                           two:[CCCallFunc actionWithTarget:self selector:@selector(swipeDone:)]]];
    else
        [self runAction:self.swipeAction = [CCMoveTo actionWithDuration:0.1f
                                                             position:CGPointZero]];
            
    self.swipeStart = ccp(-1, -1);
    
    return;
}


-(void) swipeDone:(id)sender {

    [self.invocation setArgument:&_swipeForward atIndex:2];
    [self.invocation invoke];
}


@end
