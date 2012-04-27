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
//  PearlBoxView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A box view is a plain view that renders a bounding box.
 */
@interface PearlBoxView : UIView {

    UIColor                             *_color;
    CGFloat                             _width;
    BOOL                                _filled;
}

@property (nonatomic, retain) UIColor   *color;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) BOOL      filled;

+ (id)boxed:(id)view;
+ (PearlBoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor;
+ (PearlBoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

@end
