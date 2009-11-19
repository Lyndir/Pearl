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
//  ScrollLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 23/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

typedef enum ScrollContentDirection {
    ScrollContentDirectionLeftToRight = 2 << 0,
    ScrollContentDirectionRightToLeft = 2 << 1,
    ScrollContentDirectionTopToBottom = 2 << 2,
    ScrollContentDirectionBottomToTop = 2 << 3,
} ScrollContentDirection;

@protocol ScrollLayerDelegate

-(void)didUpdateScrollWithOrigin:(CGPoint)origin to:(CGPoint)newScroll;

@end


@interface ScrollLayer : Layer {
    
    @private
    Sprite                                      *scrollPinX, *scrollPinY;
    
    CGPoint                                     dragFromPoint;
    CGPoint                                     dragFromPosition;

    CGFloat                                     scrollPerSecond;
    CGPoint                                     scrollRatio;
    CGPoint                                     scrollStep;
    ScrollContentDirection                      scrollContentDirection;
    CGSize                                      scrollContentSize;

    CGPoint                                     origin;
    CGPoint                                     scroll;
    
    BOOL                                        isTouching;
    id<NSObject, ScrollLayerDelegate>           delegate;
}

@property (readwrite) CGFloat                   scrollPerSecond;
@property (readwrite) CGPoint                   scrollRatio;
@property (readwrite) CGPoint                   scrollStep;
@property (readwrite) ScrollContentDirection    scrollContentDirection;
@property (readwrite) CGSize                    scrollContentSize;
@property (readwrite, retain) id<NSObject, ScrollLayerDelegate> delegate;

+ (ScrollLayer *)scrollWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction;
+ (ScrollLayer *)scrollNode:(CocosNode *)node direction:(ScrollContentDirection)direction;
- (id)initWithContentSize:(CGSize)contentSize direction:(ScrollContentDirection)direction;

- (void)scrollBy:(CGPoint)scrollOffset;
- (BOOL)isScrollValid:(CGPoint)scrollOffset;

- (void)didUpdateScroll;
- (CGRect)visibleRect;

@end
