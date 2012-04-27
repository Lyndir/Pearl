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
//  PearlCCScrollLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 23/09/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


typedef enum {
    PearlCCScrollContentDirectionLeftToRight = 2 << 0,
    PearlCCScrollContentDirectionRightToLeft = 2 << 1,
    PearlCCScrollContentDirectionTopToBottom = 2 << 2,
    PearlCCScrollContentDirectionBottomToTop = 2 << 3,
} PearlCCScrollContentDirection;

@protocol PearlCCScrollLayerDelegate

-(void)didUpdateScrollWithOrigin:(CGPoint)origin to:(CGPoint)newScroll;

@end


@interface PearlCCScrollLayer : CCLayer {

    @private
    CGPoint                                                                 _dragFromPoint;
    CGPoint                                                                 _dragFromPosition;

    CGFloat                                                                 _scrollPerSecond;
    CGPoint                                                                 _scrollRatio;
    CGPoint                                                                 _scrollStep;
    PearlCCScrollContentDirection _scrollContentDirection;
    CGSize                                                                  _scrollContentSize;

    CGPoint                                                                 _origin;
    CGPoint                                                                 _scroll;

    BOOL                                                                    _isTouching;
    id<NSObject, PearlCCScrollLayerDelegate>                                       _delegate;
}

@property (nonatomic, readwrite) CGFloat                                    scrollPerSecond;
@property (nonatomic, readwrite) CGPoint                                    scrollRatio;
@property (nonatomic, readwrite) CGPoint                                    scrollStep;
@property (nonatomic, readwrite) PearlCCScrollContentDirection scrollContentDirection;
@property (nonatomic, readwrite) CGSize                                     scrollContentSize;
@property (nonatomic, readwrite, retain) id<NSObject, PearlCCScrollLayerDelegate>  delegate;

+ (PearlCCScrollLayer *)scrollWithContentSize:(CGSize)contentSize direction:(PearlCCScrollContentDirection)direction;
+ (PearlCCScrollLayer *)scrollNode:(CCNode *)node direction:(PearlCCScrollContentDirection)direction;
- (id)initWithContentSize:(CGSize)contentSize direction:(PearlCCScrollContentDirection)direction;

- (void)scrollBy:(CGPoint)scrollOffset;
- (BOOL)isScrollValid:(CGPoint)scrollOffset;

- (void)didUpdateScroll;
- (CGRect)visibleRect;

@end
