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
#import "GLUtils.h"

#define kDefaultScrollPerSecond     0.01f


@interface ScrollLayer ()


- (CGPoint)limitPoint:(CGPoint)point;

@property (nonatomic, readwrite, assign) CGPoint                            dragFromPoint;
@property (nonatomic, readwrite, assign) CGPoint                            dragFromPosition;

@property (nonatomic, readwrite, assign) CGPoint                            origin;
@property (nonatomic, readwrite, assign) CGPoint                            scroll;

@property (nonatomic, readwrite, assign) BOOL                               isTouching;

@end


@implementation ScrollLayer

@synthesize dragFromPoint = _dragFromPoint;
@synthesize dragFromPosition = _dragFromPosition;
@synthesize scrollPerSecond = _scrollPerSecond;
@synthesize scrollRatio = _scrollRatio;
@synthesize scrollStep = _scrollStep;
@synthesize scrollContentDirection = _scrollContentDirection;
@synthesize scrollContentSize = _scrollContentSize;
@synthesize origin = _origin;
@synthesize scroll = _scroll;
@synthesize isTouching = _isTouching;
@synthesize delegate = _delegate;



+ (ScrollLayer *)scrollWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction {

    return [[[self alloc] initWithContentSize:contentSize direction:direction] autorelease];
}


+ (ScrollLayer *)scrollNode:(CCNode *)node direction:(ScrollContentDirection)direction {

    ScrollLayer *scrollLayer = [self scrollWithContentSize:node.contentSize direction:direction];
    [scrollLayer addChild:node];
    
    return scrollLayer;
}


- (id)initWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction {

    if (!(self = [super init]))
        return nil;
    
    self.scrollRatio             = ccp(0.0f, 1.0f);
    self.scrollPerSecond         = kDefaultScrollPerSecond;
    self.scrollContentSize       = contentSize;
    self.scrollContentDirection  = direction;
    self.isTouchEnabled     = YES;

    [self schedule:@selector(tick:)];

	return self;
}


-(void) registerWithTouchDispatcher {
    
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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
    self.dragFromPosition        = self.position;
    self.dragFromPoint           = [self.parent convertTouchToNodeSpace:touch];
    
    return self.isTouching = YES;
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint dragToPoint     = [self.parent convertTouchToNodeSpace:touch];
    self.scroll             = ccp((dragToPoint.x - self.dragFromPoint.x) * self.scrollRatio.x,
                                  (dragToPoint.y - self.dragFromPoint.y) * self.scrollRatio.y);
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Limit the target of the scroll (origin + scroll).
    self.scroll             = ccpSub([self limitPoint:ccpAdd(self.origin, self.scroll)], self.origin);
    
    // Apply the scroll step.
    self.scroll             = ccp(self.scrollStep.x? roundf(self.scroll.x / self.scrollStep.x) * self.scrollStep.x: roundf(self.scroll.x),
                                  self.scrollStep.y? roundf(self.scroll.y / self.scrollStep.y) * self.scrollStep.y: roundf(self.scroll.y));
    
    self.isTouching              = NO;
}


- (void)setScrollStep:(CGPoint)aScrollStep {
    
    // Scroll steps < 1 make no sense.
    aScrollStep.x           = fmaxf(aScrollStep.x, 1);
    aScrollStep.y           = fmaxf(aScrollStep.y, 1);
    
    _scrollStep             = aScrollStep;
}


- (void)onEnter {
    
    [super onEnter];
    
    if ([self.delegate respondsToSelector:@selector(didUpdateScrollWithOrigin:to:)])
        [self.delegate didUpdateScrollWithOrigin:self.origin to:self.scroll];
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {

    [self ccTouchEnded:touch withEvent:event];
}


- (CGPoint)limitPoint:(CGPoint)point {

    CGPoint scrollBound     = ccp(fmaxf(self.scrollContentSize.width  - self.contentSize.width,  0),
                                  fmaxf(self.scrollContentSize.height - self.contentSize.height, 0));
    CGPoint limitPoint      = point;
    
    if (self.scrollContentDirection & ScrollContentDirectionBottomToTop)
        limitPoint.y        = fminf(fmaxf(point.y, -scrollBound.y), 0);
    else if (self.scrollContentDirection & ScrollContentDirectionTopToBottom)
        limitPoint.y        = fminf(fmaxf(point.y, 0), scrollBound.y);
    else
        limitPoint.y        = 0;

    if (self.scrollContentDirection & ScrollContentDirectionLeftToRight)
        limitPoint.x        = fminf(fmaxf(point.x, -scrollBound.x), 0);
    else if (self.scrollContentDirection & ScrollContentDirectionRightToLeft)
        limitPoint.x        = fminf(fmaxf(point.x, 0), scrollBound.x);
    else
        limitPoint.x        = 0;
    
    return limitPoint;
}


- (void)setScroll:(CGPoint)newScroll {
    
    if (CGPointEqualToPoint(newScroll, self.scroll))
        return;
    
    _scroll = newScroll;
    if ([self.delegate respondsToSelector:@selector(didUpdateScrollWithOrigin:to:)])
        [self.delegate didUpdateScrollWithOrigin:self.origin to:newScroll];
}


- (void)scrollBy:(CGPoint)scrollOffset {
    
    if ([self isScrollValid:scrollOffset]) {
        self.origin              = [self limitPoint:ccpAdd(self.origin, self.scroll)];
        self.scroll         = scrollOffset;
    } else {
        self.origin              = [self limitPoint:ccpAdd(self.origin, self.scroll)];
        self.scroll         = CGPointZero;
    }
}


- (BOOL)isScrollValid:(CGPoint)scrollOffset {
    
    CGPoint target = [self limitPoint:ccpAdd(self.origin, self.scroll)];
    return !CGPointEqualToPoint([self limitPoint:ccpAdd(target, scrollOffset)], target);
}


- (CGRect)visibleRect {
    
    CGPoint visibleOrigin = ccpNeg(self.position);
    return CGRectFromCGPointAndCGSize(visibleOrigin, self.contentSize);
}


- (void)tick:(ccTime)dt {
    
    CGPoint scrollTarget    = ccpAdd(self.origin, self.scroll);
    CGPoint scrollLeft      = ccpSub(scrollTarget, self.position);
    CGFloat scrollLeftLen   = ccpLength(scrollLeft);

    if (scrollLeftLen == 0)
        return;
    
    if (scrollLeftLen <= 1) {
        // We're really close, short cut.
        if (!self.isTouching)
            [self scrollBy:CGPointZero];
        self.position       = scrollTarget;
        return;
    }

    CGPoint tickStep        = ccpMult(scrollLeft, (scrollLeftLen + 4 / kDefaultScrollPerSecond) * self.scrollPerSecond * dt);
    self.position           = ccpAdd(self.position, tickStep);
}


- (void)setPosition:(CGPoint)newPosition {
    
    super.position = newPosition;
    
    [self didUpdateScroll];
}


- (void)didUpdateScroll {
    
    // Override me if you need to update your UI as it is scrolled.
}


- (void)visit {

    if (!self.visible)
        return;
    
    glEnable(GL_SCISSOR_TEST);
    Scissor(self.parent, CGPointZero, CGPointFromCGSize(self.contentSize));
    
    [super visit];

    glDisable(GL_SCISSOR_TEST);
}


- (void)draw {
    
    [super draw];

    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    CGPoint scrollBound     = ccp(fmaxf(self.scrollContentSize.width  - self.contentSize.width,  0),
                                  fmaxf(self.scrollContentSize.height - self.contentSize.height, 0));
    CGPoint scrollProgress  = ccp(scrollBound.x? self.position.x / scrollBound.x: 0,
                                  scrollBound.y? self.position.y / scrollBound.y: 0);
    
    if (scrollBound.x) {
        CGPoint from        = ccpSub(ccp(5, 5), self.position);
        CGPoint to          = ccpSub(ccp(self.contentSize.width - 10, 5), self.position);
        CGPoint scrollPointFrom, scrollPointTo;
        if (self.scrollContentDirection & ScrollContentDirectionLeftToRight) {
            scrollPointFrom = ccpSub(from, ccpMult(ccpSub(to, from), scrollProgress.x * 0.95f));
            scrollPointTo   = ccpSub(from, ccpMult(ccpSub(to, from), scrollProgress.x * 0.95f - 0.05f));
        }
        else if (self.scrollContentDirection & ScrollContentDirectionRightToLeft) {
            scrollPointFrom = ccpAdd(to, ccpMult(ccpSub(from, to), scrollProgress.x * 0.95f));
            scrollPointTo   = ccpAdd(to, ccpMult(ccpSub(from, to), scrollProgress.x * 0.95f + 0.05f));
        } else
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unsupported scrollContentDirection" userInfo:nil];
        scrollPointFrom     = ccpAdd(scrollPointFrom, ccp(0, 2));
        scrollPointTo       = ccpAdd(scrollPointTo, ccp(0, 2));

        DrawLinesTo(from, &to, 1, ccc4(0xFF, 0xFF, 0xFF, 0x88), 1);
        DrawLinesTo(scrollPointFrom, &scrollPointTo, 1, ccc4(0xFF, 0xFF, 0xFF, 0x88), 2);
    }
    if (scrollBound.y) {
        CGPoint from        = ccpSub(ccp(self.contentSize.width - 5, 5), self.position);
        CGPoint to          = ccpSub(ccp(self.contentSize.width - 5, self.contentSize.height - 10), self.position);
        CGPoint scrollPointFrom, scrollPointTo;
        if (self.scrollContentDirection & ScrollContentDirectionTopToBottom) {
            scrollPointFrom = ccpAdd(to, ccpMult(ccpSub(from, to), scrollProgress.y * 0.95f));
            scrollPointTo   = ccpAdd(to, ccpMult(ccpSub(from, to), scrollProgress.y * 0.95f + 0.05f));
        }
        else if (self.scrollContentDirection & ScrollContentDirectionBottomToTop) {
            scrollPointFrom = ccpSub(from, ccpMult(ccpSub(to, from), scrollProgress.y * 0.95f));
            scrollPointTo   = ccpSub(from, ccpMult(ccpSub(to, from), scrollProgress.y * 0.95f + 0.05f));
        } else
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unsupported scrollContentDirection" userInfo:nil];
        scrollPointFrom     = ccpAdd(scrollPointFrom, ccp(-2, 0));
        scrollPointTo       = ccpAdd(scrollPointTo, ccp(-2, 0));

        DrawLinesTo(from, &to, 1, ccc4(0xFF, 0xFF, 0xFF, 0x88), 1);
        DrawLinesTo(scrollPointFrom, &scrollPointTo, 1, ccc4(0xFF, 0xFF, 0xFF, 0x88), 2);
    }
    
    glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}


- (void)dealloc {

    self.delegate = nil;

    [super dealloc];
}

@end
