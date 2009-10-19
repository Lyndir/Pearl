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


@interface ScrollLayer : Layer {
    
    @private
    CGPoint                                     dragFromPoint;
    CGPoint                                     dragFromPosition;

    CGFloat                                     scrollPerSecond;
    CGPoint                                     scrollRatio;
    CGSize                                      scrollableContentSize;

    CGPoint                                     origin;
    CGPoint                                     scroll;
}

@property (readwrite) CGFloat                   scrollPerSecond;
@property (readwrite) CGPoint                   scrollRatio;
@property (readwrite) CGSize                    scrollableContentSize;

@property (readwrite) CGPoint                   origin;
@property (readwrite) CGPoint                   scroll;

- (void)didUpdateScroll;
- (CGRect)visibleRect;

@end
