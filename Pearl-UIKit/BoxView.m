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
    
    if (self.filled) {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
        CGContextFillRect(UIGraphicsGetCurrentContext(), self.bounds);
    } else {
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
        CGContextStrokeRectWithWidth(UIGraphicsGetCurrentContext(), self.bounds, self.width);
    }
}

@end
