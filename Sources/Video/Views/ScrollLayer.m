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
//  ScrollLayer.m
//  iLibs
//
//  Created by Maarten Billemont on 23/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "ScrollLayer.h"

#define kDefaultScrollPerSecond     0.01f


@interface ScrollLayer ()

- (CGPoint)limitPoint:(CGPoint)point;

@end


@implementation ScrollLayer

@synthesize scrollPerSecond, scrollRatio, scrollableContentSize;
@synthesize origin, scroll;


- (id)init {

    if (!(self = [super init]))
        return nil;
    
    self.isTouchEnabled     = YES;
    scrollRatio             = ccp(0.0f, 1.0f);
    scrollPerSecond         = kDefaultScrollPerSecond;
    
    [self schedule:@selector(tick:)];

	return self;
}


-(void) registerWithTouchDispatcher {
    
	[[TouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Test if touch was on us.
    CGRect graphRect;
    graphRect.origin        = CGPointZero;
    graphRect.size          = self.contentSize;
    if (!CGRectContainsPoint(graphRect, [self.parent convertTouchToNodeSpace:touch]))
        return NO;
    
    // Instantly apply remaining scroll & reset it.
    origin                  = [self limitPoint:ccpAdd(origin, scroll)];
    scroll                  = CGPointZero;

    // Remember where the dragging began.
    dragFromPosition        = self.position;
    dragFromPoint           = [self.parent convertTouchToNodeSpace:touch];
    
    return YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint dragToPoint     = [self.parent convertTouchToNodeSpace:touch];
    scroll                  = ccp((dragToPoint.x - dragFromPoint.x) * scrollRatio.x,
                                  (dragToPoint.y - dragFromPoint.y) * scrollRatio.y);
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    scroll              = ccpSub([self limitPoint:ccpAdd(origin, scroll)], origin);
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {

    [self ccTouchEnded:touch withEvent:event];
}


- (CGPoint)limitPoint:(CGPoint)point {

    CGPoint maxScroll       = ccp(fmaxf(scrollableContentSize.width  - self.contentSize.width,  0),
                                  fmaxf(scrollableContentSize.height - self.contentSize.height, 0));
    CGPoint minScroll       = CGPointZero;
    
    CGPoint limitPoint      = ccp(fminf(fmaxf(point.x, minScroll.x), maxScroll.x),
                                  fminf(fmaxf(point.y, minScroll.y), maxScroll.y));
    
    return limitPoint;
}


- (CGRect)visibleRect {
    
    CGPoint visibleOrigin = ccpNeg(self.position);
    return CGRectFromPointAndSize(visibleOrigin, self.contentSize);
}


- (void)tick:(ccTime)dt {
    
    CGPoint scrollTarget    = ccpAdd(origin, scroll);
    CGPoint scrollLeft      = ccpSub(scrollTarget, self.position);
    CGFloat scrollLeftLen   = ccpLength(scrollLeft);

    if (scrollLeftLen == 0)
        return;
    
    if (scrollLeftLen <= 1) {
        // We're really close, short cut.
        self.position       = scrollTarget;
        return;
    }

    CGPoint scrollStep      = ccpMult(scrollLeft, (scrollLeftLen + 4 / kDefaultScrollPerSecond) * scrollPerSecond * dt);
    self.position           = ccpAdd(self.position, scrollStep);
    [self didUpdateScroll];
}


- (void)didUpdateScroll {
    
    // Override me if you need to update your UI as it is scrolled.
}


- (void)visit {

    if (!visible)
        return;
    
    glEnable(GL_SCISSOR_TEST);
    Scissor(self.parent, CGPointZero, CGPointFromSize(self.contentSize));
    
    [super visit];

    glDisable(GL_SCISSOR_TEST);
}


@end
