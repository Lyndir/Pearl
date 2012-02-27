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
//  PearlGradientView.m
//  Pearl
//
//  Created by Maarten Billemont on 12/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlGradientView.h"
#import "PearlLayout.h"


@implementation PearlGradientView


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
