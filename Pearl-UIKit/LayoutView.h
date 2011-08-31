//
//  LayoutView.h
//  Pearl
//
//  Created by Maarten Billemont on 28/02/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GravityNorth,
    GravityEast,
    GravitySouth,
    GravityWest,
} Gravity;

@interface LayoutView : UIView {
    
}

+ (LayoutView *)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth
                        gravity:(Gravity)gravity;
+ (LayoutView *)viewWithContent:(UIView *)contentView padHeight:(CGFloat)padHeight
                        gravity:(Gravity)gravity;
+ (LayoutView *)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth padHeight:(CGFloat)padHeight
                        gravity:(Gravity)gravity;

- (id)initWithContent:(UIView *)contentView width:(CGFloat)width height:(CGFloat)height gravity:(Gravity)gravity;

@end
