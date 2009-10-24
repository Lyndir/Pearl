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

@property (readwrite) CGPoint       scroll;

- (CGPoint)limitPoint:(CGPoint)point;

@end


@implementation ScrollLayer

@synthesize scrollPerSecond, scrollRatio, scrollStep, scrollContentDirection, scrollContentSize, delegate;
@synthesize scroll;


- (id)initWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction {

    if (!(self = [super init]))
        return nil;
    
    self.isTouchEnabled     = YES;
    scrollRatio             = ccp(0.0f, 1.0f);
    scrollPerSecond         = kDefaultScrollPerSecond;
    scrollContentSize       = contentSize;
    scrollContentDirection  = direction;
    
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
    [self scrollBy:CGPointZero];

    // Remember where the dragging began.
    dragFromPosition        = self.position;
    dragFromPoint           = [self.parent convertTouchToNodeSpace:touch];
    
    return isTouching = YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint dragToPoint     = [self.parent convertTouchToNodeSpace:touch];
    self.scroll             = ccp((dragToPoint.x - dragFromPoint.x) * scrollRatio.x,
                                  (dragToPoint.y - dragFromPoint.y) * scrollRatio.y);
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Limit the target of the scroll (origin + scroll).
    self.scroll             = ccpSub([self limitPoint:ccpAdd(origin, scroll)], origin);
    
    // Apply the scroll step.
    self.scroll             = ccp(roundf(scroll.x / scrollStep.x) * scrollStep.x,
                                  roundf(scroll.y / scrollStep.y) * scrollStep.y);
    
    isTouching              = NO;
}


- (void)setScrollStep:(CGPoint)aScrollStep {
    
    // Scroll steps < 1 make no sense.
    aScrollStep.x           = fmaxf(aScrollStep.x, 1);
    aScrollStep.y           = fmaxf(aScrollStep.y, 1);
    
    scrollStep              = aScrollStep;
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {

    [self ccTouchEnded:touch withEvent:event];
}


- (CGPoint)limitPoint:(CGPoint)point {

    CGPoint scrollBound     = ccp(fmaxf(scrollContentSize.width  - self.contentSize.width,  0),
                                  fmaxf(scrollContentSize.height - self.contentSize.height, 0));
    CGPoint limitPoint      = point;
    
    if (scrollContentDirection & ScrollContentDirectionBottomToTop)
        limitPoint.y        = fminf(fmaxf(point.y, -scrollBound.y), 0);
    else if (scrollContentDirection & ScrollContentDirectionTopToBottom)
        limitPoint.y        = fminf(fmaxf(point.y, 0), scrollBound.y);
    else
        limitPoint.y        = 0;

    if (scrollContentDirection & ScrollContentDirectionLeftToRight)
        limitPoint.x        = fminf(fmaxf(point.x, -scrollBound.x), 0);
    else if (scrollContentDirection & ScrollContentDirectionRightToLeft)
        limitPoint.x        = fminf(fmaxf(point.x, 0), scrollBound.x);
    else
        limitPoint.x        = 0;
    
    return limitPoint;
}


- (void)setScroll:(CGPoint)newScroll {
    
    if (CGPointEqualToPoint(newScroll, scroll))
        return;
    
    scroll = newScroll;
    if ([delegate respondsToSelector:@selector(didUpdateScrollWithOrigin:to:)])
        [delegate didUpdateScrollWithOrigin:origin to:newScroll];
}


- (void)scrollBy:(CGPoint)scrollOffset {
    
    if ([self isScrollValid:scrollOffset]) {
        origin              = [self limitPoint:ccpAdd(origin, scroll)];
        self.scroll         = scrollOffset;
    } else {
        origin              = [self limitPoint:ccpAdd(origin, scroll)];
        self.scroll         = CGPointZero;
    }
}


- (BOOL)isScrollValid:(CGPoint)scrollOffset {
    
    CGPoint target = [self limitPoint:ccpAdd(origin, scroll)];
    return !CGPointEqualToPoint([self limitPoint:ccpAdd(target, scrollOffset)], target);
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
        if (!isTouching)
            [self scrollBy:CGPointZero];
        self.position       = scrollTarget;
        return;
    }

    CGPoint tickStep        = ccpMult(scrollLeft, (scrollLeftLen + 4 / kDefaultScrollPerSecond) * scrollPerSecond * dt);
    self.position           = ccpAdd(self.position, tickStep);
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
