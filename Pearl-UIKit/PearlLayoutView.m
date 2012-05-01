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
//  PearlLayoutView.m
//  Pearl
//
//  Created by Maarten Billemont on 28/02/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import "PearlLayoutView.h"


@implementation PearlLayoutView

+ (PearlLayoutView *)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth
                        gravity:(PearlLayoutGravity)gravity {
    
    return [self viewWithContent:contentView padWidth:padWidth padHeight:0 gravity:gravity];
}

+ (PearlLayoutView *)viewWithContent:(UIView *)contentView padHeight:(CGFloat)padHeight
                        gravity:(PearlLayoutGravity)gravity {
    
    return [self viewWithContent:contentView padWidth:0 padHeight:padHeight gravity:gravity];
}

+ (PearlLayoutView *)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth padHeight:(CGFloat)padHeight
                        gravity:(PearlLayoutGravity)gravity {
    
    return [[[self alloc]
             initWithContent:contentView
             width:contentView.frame.size.width + padWidth
             height:contentView.frame.size.height + padHeight
             gravity:gravity]
            autorelease];
}

- (id)initWithContent:(UIView *)contentView width:(CGFloat)width height:(CGFloat)height gravity:(PearlLayoutGravity)gravity {
    
    if (!(self = [super initWithFrame:CGRectMake(0, 0, width, height)]))
        return self;
    
    CGSize size = contentView.frame.size;
    CGFloat x = 0, y = 0;
    switch (gravity) {
        case PearlLayoutGravityNorth:
            break;
        case PearlLayoutGravityEast:
            x = width - size.width;
            break;
        case PearlLayoutGravitySouth:
            y = height - size.height;
            break;
        case PearlLayoutGravityWest:
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
