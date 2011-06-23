//
//  BoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "BoxView.h"
#import "UIColor-Expanded.h"
#import "Layout.h"


@implementation BoxView
@synthesize color = _color;

+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor {
    
    return [[[self alloc] initWithFrame:aFrame color:aColor] autorelease];
}

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor {
    
    if (!(self = [super initWithFrame:aFrame]))
        return self;
    
    self.color = aColor;
    self.userInteractionEnabled = NO;
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.superview && [keyPath isEqualToString:@"bounds"])
        self.frame = (CGRect){CGPointZero, self.superview.bounds.size};
}

- (void)drawRect:(CGRect)rect {
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.color.CGColor);
    CGContextStrokeRectWithWidth(UIGraphicsGetCurrentContext(), self.bounds, 2);
}

@end
