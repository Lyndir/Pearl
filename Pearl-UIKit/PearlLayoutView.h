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
//  PearlLayoutView.h
//  Pearl
//
//  Created by Maarten Billemont on 28/02/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import <UIKit/UIKit.h>

__BEGIN_DECLS
typedef enum {
    PearlLayoutGravityNorth,
    PearlLayoutGravityEast,
    PearlLayoutGravitySouth,
    PearlLayoutGravityWest
} PearlLayoutGravity;
__END_DECLS

@interface PearlLayoutView : UIView {
}

+ (instancetype)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth
                        gravity:(PearlLayoutGravity)gravity;
+ (instancetype)viewWithContent:(UIView *)contentView padHeight:(CGFloat)padHeight
                        gravity:(PearlLayoutGravity)gravity;
+ (instancetype)viewWithContent:(UIView *)contentView padWidth:(CGFloat)padWidth padHeight:(CGFloat)padHeight
                        gravity:(PearlLayoutGravity)gravity;

- (id)initWithContent:(UIView *)contentView width:(CGFloat)width height:(CGFloat)height gravity:(PearlLayoutGravity)gravity;

@end
