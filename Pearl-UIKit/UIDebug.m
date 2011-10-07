//
//  UIUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import "UIDebug.h"


@implementation UIDebug

static UIView *UIDebug_debugView;
static CGFloat autoWidth;

+ (UIView *)debugView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    if (!UIDebug_debugView) {
        [window addSubview:UIDebug_debugView = [[UIView alloc] initWithFrame:window.bounds]];
        UIDebug_debugView.userInteractionEnabled = NO;
        UIDebug_debugView.opaque = NO;
        UIDebug_debugView.alpha = 0.7f;
        [self clear];
    }

    [window bringSubviewToFront:UIDebug_debugView];
    return UIDebug_debugView;
}

+ (void)clear {
    
    [[[self debugView] subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    autoWidth = 5;
}

+ (BoxView *)showRect:(CGRect)rect color:(UIColor *)color {
    
    autoWidth = fmaxf(autoWidth - 1, 1);
    
    return [self showRect:rect color:color width:autoWidth];
}

+ (BoxView *)showRect:(CGRect)rect color:(UIColor *)color width:(CGFloat)width {
    
    BoxView *box = [BoxView boxWithFrame:rect color:color width:width];
    [[self debugView] addSubview:box];

    return box;
}

+ (BoxView *)fillRect:(CGRect)rect color:(UIColor *)color {

    BoxView *box = [self showRect:rect color:color];
    box.filled = YES;
    box.alpha = 0.7f;
    
    return box;
}

@end
