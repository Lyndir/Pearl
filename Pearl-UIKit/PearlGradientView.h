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
//  PearlGradientView.h
//  Pearl
//
//  Created by Maarten Billemont on 12/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A gradient view is a plain view that renders a gradient shading from top to bottom in its content area.
 */
@interface PearlGradientView : UIView {

@private
    CGFloat *components;
}

/** Create a gradient view that renders a gradient which begins at the top with the given topColor
 *  and ends at the bottom with the given bottomColor. */
- (id)initWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

@end
