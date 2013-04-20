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
//  PearlBoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@implementation PearlMessageView

@synthesize corners = _corners, fill = _fill, radii = _radii;

- (id)initWithFrame:(CGRect)aFrame {

    if (!(self = [super initWithFrame:aFrame]))
        return self;

    NSAssert([NSThread currentThread].isMainThread, @"Should be on the main thread; was on thread: %@", [NSThread currentThread].name);

    return self;
}

- (void)drawRect:(CGRect)rect {

    if (!_initialized) {
        self.layer.masksToBounds = NO;
        //self.layer.shadowColor = [UIColor whiteColor].CGColor;
        //self.layer.shadowOffset = CGSizeMake(0, 2);
        //self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5f;

        self.corners = UIRectCornerAllCorners;
        self.fill = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.radii = CGSizeMake( 10, 10 );

        _initialized = YES;
    }

    [self.fill setFill];
    [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.corners cornerRadii:self.radii] fill];
}

@end
