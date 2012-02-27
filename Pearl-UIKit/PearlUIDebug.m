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
//  PearlUIUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlUIDebug.h"


@implementation PearlUIDebug

static CGFloat autoWidth = 5;

+ (UIView *)view {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    static UIView *instance;
    if (!instance) {
        [window addSubview:instance = [[UIView alloc] initWithFrame:window.bounds]];
        instance.userInteractionEnabled = NO;
        instance.opaque = NO;
        instance.alpha = 0.7f;
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
    box.alpha = 0.7f;
    
    return box;
}

@end
