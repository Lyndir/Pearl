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
