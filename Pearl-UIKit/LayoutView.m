//
//  LayoutView.m
//  Pearl
//
//  Created by Maarten Billemont on 28/02/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import "LayoutView.h"


@implementation LayoutView

+ (LayoutView *)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth
                        gravity:(Gravity)gravity {
    
    return [self viewWithContent:contentView padWidth:padWidth padHeight:0 gravity:gravity];
}

+ (LayoutView *)viewWithContent:(UIView *)contentView padHeight:(CGFloat)padHeight
                        gravity:(Gravity)gravity {
    
    return [self viewWithContent:contentView padWidth:0 padHeight:padHeight gravity:gravity];
}

+ (LayoutView *)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth padHeight:(CGFloat)padHeight
                        gravity:(Gravity)gravity {
    
    return [[[self alloc]
             initWithContent:contentView
             width:contentView.frame.size.width + padWidth
             height:contentView.frame.size.height + padHeight
             gravity:gravity]
            autorelease];
}

- (id)initWithContent:(UIView *)contentView width:(CGFloat)width height:(CGFloat)height gravity:(Gravity)gravity {
    
    if (!(self = [super initWithFrame:CGRectMake(0, 0, width, height)]))
        return self;
    
    CGSize size = contentView.frame.size;
    CGFloat x = 0, y = 0;
    switch (gravity) {
        case GravityNorth:
            break;
        case GravityEast:
            x = width - size.width;
            break;
        case GravitySouth:
            y = height - size.height;
            break;
        case GravityWest:
            break;
    }
    
    [self addSubview:contentView];
    contentView.frame = (CGRect){CGPointMake(x, y), size};

    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

@end
