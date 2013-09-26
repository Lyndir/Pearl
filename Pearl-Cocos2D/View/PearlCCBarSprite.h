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
//  PearlCCBarSprite.h
//  Pearl
//
//  Created by Maarten Billemont on 27/06/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCBarSprite : CCLayer {

@private
    CCTexture2D *_head, __strong **_body, *_tail;

    CGFloat    _age;
    NSUInteger _bodyFrame, _bodyFrames;

    BOOL    _animatedTargetting;
    ccTime  _smoothTimeElapsed;
    CGPoint _target;

    CGPoint _current;
    float   _currentLength;

    CGSize     _textureSize;
    int _uniformColor;
}

@property (nonatomic, readwrite, assign) CGPoint    target;
@property (nonatomic, readwrite, assign) CGSize     textureSize;
@property (nonatomic, readwrite, assign) int uniformColor;


#pragma mark ###############################
#pragma mark Lifecycle

- (id)initWithHead:(NSString *)bundleHeadReference body:(NSString *)bundleBodyReference withFrames:(NSUInteger)bodyFrameCount
              tail:(NSString *)bundleTailReference animatedTargetting:(BOOL)anAnimatedTargetting;

@end
