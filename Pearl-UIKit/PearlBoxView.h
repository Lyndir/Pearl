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
IB_DESIGNABLE
@interface PearlBoxView : UIView {

    UIColor *_color;
    CGFloat _width;
    BOOL _filled;
}

@property(nonatomic, retain) IBInspectable UIColor *color;
@property(nonatomic, assign) IBInspectable CGFloat width;
@property(nonatomic, assign) IBInspectable BOOL filled;

+ (id)boxed:(id)view;
+ (instancetype)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor;
+ (instancetype)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

@end
