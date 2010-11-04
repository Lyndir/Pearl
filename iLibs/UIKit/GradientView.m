//
//  GradientView.m
//  iLibs
//
//  Created by Maarten Billemont on 12/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "GradientView.h"
#import "UIColor-Expanded.h"
#import "Layout.h"


@implementation GradientView


- (id)initWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor {
    
    if (!(self = [super init]))
        return nil;
    
    CGFloat newComponents[2 * 4] = {
        topColor.red,       topColor.green,     topColor.blue,      topColor.alpha,
        bottomColor.red,    bottomColor.green,  bottomColor.blue,   bottomColor.alpha,
    };
    
    components = memcpy(malloc(sizeof(newComponents)), newComponents, sizeof(newComponents));
    
    return self;
}

- (void)layoutSubviews {
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGColorSpaceRef newColorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef newGradient = CGGradientCreateWithColorComponents(newColorSpace, components, NULL, 2);
    CGColorSpaceRelease(newColorSpace);
    
    CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), newGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
    CGGradientRelease(newGradient);
}

@end
