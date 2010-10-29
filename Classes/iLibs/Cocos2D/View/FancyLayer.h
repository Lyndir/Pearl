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
//  FancyLayer.h
//  iLibs
//
//  Created by Maarten Billemont on 18/12/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//


typedef struct Margin {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
} Margin;

static inline Margin
margin(CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {

    Margin margin = { top, right, bottom, left };
    return margin;
}

@interface FancyLayer : Layer <CocosNodeRGBA> {

    CGSize                                   _contentSize;
    Margin                                   _outerPadding;
    Margin                                   _padding;
    float                                    _innerRatio;
    ccColor4B                                _backColor, _colorGradient;

    GLuint                                   _vertexBuffer;
    GLuint                                   _colorBuffer;
}

@property (nonatomic, readonly) CGSize      contentSize;
@property (nonatomic, readwrite) ccColor4B  colorGradient;
@property (nonatomic, readwrite) Margin     outerPadding;
@property (nonatomic, readwrite) Margin     padding;
@property (nonatomic, readwrite) float      innerRatio;

-(void) update;

@end
