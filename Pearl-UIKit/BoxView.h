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
//  BoxView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A box view is a plain view that renders a bounding box.
 */
@interface BoxView : UIView {

    UIColor                             *_color;
    CGFloat                             _width;
    BOOL                                _filled;
}

@property (nonatomic, retain) UIColor   *color;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) BOOL      filled;

+ (id)boxed:(id)view;
+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor;
+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

@end
