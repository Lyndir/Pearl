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
//  UIScrollView(PearlFlashingIndicators)
//
//  Created by Maarten Billemont on 09/06/12.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView(PearlFlashingIndicators)

- (void)flashScrollIndicatorsContinuously;
- (void)flashScrollIndicatorsContinuouslyAfterSeconds:(float)seconds;

@end
