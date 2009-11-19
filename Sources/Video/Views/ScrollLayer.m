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


+ (ScrollLayer *)scrollWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction {

    return [[[self alloc] initWithContentSize:contentSize direction:direction] autorelease];
}


+ (ScrollLayer *)scrollNode:(CocosNode *)node direction:(ScrollContentDirection)direction {

    ScrollLayer *scrollLayer = [self scrollWithContentSize:node.contentSize direction:direction];
    [scrollLayer addChild:node];
    
    return scrollLayer;
}


- (id)initWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction {

    if (!(self = [super init]))
        return nil;
    
    scrollRatio             = ccp(0.0f, 1.0f);
    scrollPerSecond         = kDefaultScrollPerSecond;
    scrollContentSize       = contentSize;
    scrollContentDirection  = direction;
    scrollPinX              = [[Sprite alloc] initWithFile:@"scroll.pin.png"];
    scrollPinY              = [[Sprite alloc] initWithFile:@"scroll.pin.png"];
    scrollPinY.rotation     = -90;
    ccBlendFunc blendFunc;
    blendFunc.src           = GL_ONE;
    blendFunc.dst           = GL_ONE_MINUS_SRC_ALPHA;
    scrollPinX.blendFunc    = blendFunc;
    scrollPinY.blendFunc    = blendFunc;
    [self addChild:scrollPinX];
    [self addChild:scrollPinY];

    self.isTouchEnabled     = YES;
    self.position           = CGPointZero;

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


- (void)onEnter {
    
    [super onEnter];
    
    if ([delegate respondsToSelector:@selector(didUpdateScrollWithOrigin:to:)])
        [delegate didUpdateScrollWithOrigin:origin to:scroll];
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
}


- (void)setScrollContentSize:(CGSize)newScrollContentSize {
    
    scrollContentSize       = newScrollContentSize;
    self.position           = self.position;
}


- (void)setContentSize:(CGSize)newContentSize {
    
    super.contentSize       = newContentSize;
    self.position           = self.position;
}    


- (void)setPosition:(CGPoint)newPosition {
    
    super.position = newPosition;

    CGPoint scrollBound     = ccp(fmaxf(scrollContentSize.width  - self.contentSize.width,  0),
                                  fmaxf(scrollContentSize.height - self.contentSize.height, 0));
    CGPoint scrollProgress  = ccp(scrollBound.x? self.position.x / scrollBound.x: 0,
                                  scrollBound.y? self.position.y / scrollBound.y: 0);
    
    scrollPinX.visible      = scrollBound.x != 0;
    scrollPinY.visible      = scrollBound.y != 0;
    
    if (scrollPinX.visible) {
        CGPoint from        = ccpSub(ccp(5 + scrollPinY.contentSize.width / 2, 5),
                                     self.position);
        CGPoint to          = ccpSub(ccp(self.contentSize.width - 10 - scrollPinY.contentSize.width / 2, 5),
                                     self.position);
        if (scrollContentDirection & ScrollContentDirectionLeftToRight)
            scrollPinX.position = ccpSub(from, ccpMult(ccpSub(to, from), scrollProgress.x));
        else if (scrollContentDirection & ScrollContentDirectionRightToLeft)
            scrollPinX.position = ccpAdd(to, ccpMult(ccpSub(from, to), scrollProgress.x));
    }
    if (scrollPinY.visible) {
        CGPoint from        = ccpSub(ccp(self.contentSize.width - 5,
                                         5 + scrollPinY.contentSize.width / 2),
                                     self.position);
        CGPoint to          = ccpSub(ccp(self.contentSize.width - 5,
                                         self.contentSize.height - 10 - scrollPinY.contentSize.width / 2),
                                     self.position);
        if (scrollContentDirection & ScrollContentDirectionTopToBottom)
            scrollPinY.position = ccpAdd(to, ccpMult(ccpSub(from, to), scrollProgress.y));
        else if (scrollContentDirection & ScrollContentDirectionBottomToTop)
            scrollPinY.position = ccpSub(from, ccpMult(ccpSub(to, from), scrollProgress.y));
    }
    
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


- (void)draw {
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    if (scrollPinX.visible) {
        CGPoint from        = ccpSub(ccp(5, 5), self.position);
        CGPoint to          = ccpSub(ccp(self.contentSize.width - 10, 5), self.position);

        DrawLinesTo(from, &to, 1, ccc4(0xFF, 0xFF, 0xFF, 0x88), 1);
    }
    if (scrollPinY.visible) {
        CGPoint from        = ccpSub(ccp(self.contentSize.width - 5, 5), self.position);
        CGPoint to          = ccpSub(ccp(self.contentSize.width - 5, self.contentSize.height - 10), self.position);
        
        DrawLinesTo(from, &to, 1, ccc4(0xFF, 0xFF, 0xFF, 0x88), 1);
    }
    
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}


@end
