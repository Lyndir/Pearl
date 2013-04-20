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

@implementation UIScrollView(PearlFlashingIndicators)

- (void)flashScrollIndicatorsContinuously {

    [self flashScrollIndicatorsContinuouslyAfterSeconds:3];
}

- (void)flashScrollIndicatorsContinuouslyAfterSeconds:(float)seconds {

    __weak UIScrollView *wSelf = self;
    if (!(self.tracking || self.dragging || self.decelerating))
        [self flashScrollIndicators];

    dispatch_after( dispatch_time( DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC) ), dispatch_get_main_queue(), ^{
        [wSelf flashScrollIndicatorsContinuouslyAfterSeconds:seconds];
    } );
}

@end
