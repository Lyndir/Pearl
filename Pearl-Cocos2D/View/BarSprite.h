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
//  BarSprite.h
//  Pearl
//
//  Created by Maarten Billemont on 27/06/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface BarSprite : CCLayer {

@private
    CCTexture2D                                     *_head, **_body, *_tail;

    CGFloat                                         _age;
    NSUInteger                                      _bodyFrame, _bodyFrames;

    BOOL                                            _animatedTargetting;
    ccTime                                          _smoothTimeElapsed;
    CGPoint                                         _target;

    CGPoint                                         _current;
    CGFloat                                         _currentLength;

    CGSize                                          _textureSize;
}

@property (nonatomic, readwrite, assign) CGPoint    target;
@property (nonatomic, readwrite, assign) CGSize     textureSize;


#pragma mark ###############################
#pragma mark Lifecycle

- (id) initWithHead:(NSString *)bundleHeadReference body:(NSString *)bundleBodyReference withFrames:(NSUInteger)bodyFrameCount tail:(NSString *)bundleTailReference animatedTargetting:(BOOL)anAnimatedTargetting;

@end
