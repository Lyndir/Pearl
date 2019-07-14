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
//  PearlMessageView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A message view is a plain view that renders a backdrop suitable for displaying a message in.
 */
IB_DESIGNABLE @interface PearlMessageView : UIView

@property(nonatomic, assign) IBInspectable UIRectCorner corners;
@property(nonatomic, retain) IBInspectable UIColor *fill;
@property(nonatomic, assign) IBInspectable CGSize radii;

@end
