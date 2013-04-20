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
//  PearlGradientView.m
//  Pearl
//
//  Created by Maarten Billemont on 12/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

@implementation PearlGradientView

- (id)initWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {

    if (!(self = [super init]))
        return nil;

    NSAssert([NSThread currentThread].isMainThread, @"Should be on the main thread; was on thread: %@", [NSThread currentThread].name);

    CGFloat newComponents[2 * 4] = {
            topColor.red, topColor.green, topColor.blue, topColor.alpha,
            bottomColor.red, bottomColor.green, bottomColor.blue, bottomColor.alpha,
    };

    components = calloc( 2 * 4, sizeof(CGFloat) );
    memcpy(components, newComponents, sizeof(newComponents));

    return self;
}

- (void)layoutSubviews {

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGColorSpaceRef newColorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef newGradient = CGGradientCreateWithColorComponents( newColorSpace, components, NULL, 2 );
    CGColorSpaceRelease( newColorSpace );

    CGContextDrawLinearGradient( UIGraphicsGetCurrentContext(), newGradient, CGPointZero, CGPointMake( 0, rect.size.height ), 0 );
    CGGradientRelease( newGradient );
}

- (void)dealloc {

    free( components );
}

@end
