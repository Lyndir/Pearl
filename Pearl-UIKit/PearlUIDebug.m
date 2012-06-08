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
//  PearlUIUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//


@implementation PearlUIDebug

static CGFloat autoWidth = 5;

+ (UIView *)view {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    static UIView *instance;
    if (!instance) {
        [window addSubview:instance = [[UIView alloc] initWithFrame:window.bounds]];
        instance.userInteractionEnabled = NO;
        instance.opaque                 = NO;
        instance.alpha                  = 0.7f;
        [self clear];
    }

    [window bringSubviewToFront:instance];
    return instance;
}

+ (void)clear {

    [[[self view] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    autoWidth = 5;
}

+ (PearlBoxView *)showRect:(CGRect)rect color:(UIColor *)color {

    autoWidth = fmaxf(autoWidth - 1, 1);

    return [self showRect:rect color:color width:autoWidth];
}

+ (PearlBoxView *)showRect:(CGRect)rect color:(UIColor *)color width:(CGFloat)width {

    PearlBoxView *box = [PearlBoxView boxWithFrame:rect color:color width:width];
    [[self view] addSubview:box];

    return box;
}

+ (PearlBoxView *)fillRect:(CGRect)rect color:(UIColor *)color {

    PearlBoxView *box = [self showRect:rect color:color];
    box.filled = YES;
    box.alpha  = 0.7f;

    return box;
}

@end
