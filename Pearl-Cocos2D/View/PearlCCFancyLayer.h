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
//  PearlCCFancyLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 18/12/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"

typedef struct {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
} PearlMargin;

static inline PearlMargin PearlMarginMake(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {

    PearlMargin margin = {top, right, bottom, left};
    return margin;
}

@interface PearlCCFancyLayer : CCLayer<CCRGBAProtocol> {

    PearlMargin _outerPadding;
    PearlMargin _padding;
    float       _innerRatio;
    ccColor4B   _backColor, _colorGradient;

    GLuint _vertexBuffer;
    GLuint _colorBuffer;
}

@property (nonatomic, readwrite) ccColor4B   colorGradient;
@property (nonatomic, readwrite) PearlMargin outerPadding;
@property (nonatomic, readwrite) PearlMargin padding;
@property (nonatomic, readwrite) GLfloat     innerRatio;

- (void)update;

@end
