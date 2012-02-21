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
//  BoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "BoxView.h"
#import "Layout.h"
#import "UIUtils.h"


@implementation BoxView
@synthesize color = _color, width = _width, filled = _filled;

+ (id)boxed:(id)view {
    
    [UIUtils showBoundingBoxForView:view];
    return view;
}

+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor {
    
    return [self boxWithFrame:aFrame color:aColor width:2];
}

+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)aWidth {
    
    return [[[self alloc] initWithFrame:aFrame color:aColor width:aWidth] autorelease];
}

- (id)init {
    
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)aFrame {
    
    return [self initWithFrame:aFrame color:[UIColor redColor] width:2];
}

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)aWidth {
    
    if (!(self = [super initWithFrame:aFrame]))
        return self;
    
    self.color = aColor;
    self.width = aWidth;
    self.userInteractionEnabled = NO;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.superview && [keyPath isEqualToString:@"bounds"])
        self.frame = (CGRect){CGPointZero, self.superview.bounds.size};
}

- (void)drawRect:(CGRect)rect {
    
    /* If created by means of XIB deserialization, -init isn't called. */
    if (!self.color) {
        self.color = [UIColor redColor];
        self.width = 2;
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    
    /* Draw our content box. */
    if (self.filled) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
    } else {
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
        CGContextStrokeRectWithWidth(UIGraphicsGetCurrentContext(), self.bounds, self.width);
    }
}

@end
