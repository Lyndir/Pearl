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
//  UIControl_PearlBlocks
//
//  Created by Maarten Billemont on 02/06/12.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl(PearlBlocks)

- (void)addActionForControlEvents:(UIControlEvents)controlEvents
                           action:(void ( ^ )(UIControl *sender, UIEvent *event))block;

/** @deprecated */
- (void)addTargetBlock:(void (^)(UIControl *sender, UIEvent *event))block
      forControlEvents:(UIControlEvents)controlEvents DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
