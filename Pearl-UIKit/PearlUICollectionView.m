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
//  PearlUICollectionView.h
//  PearlUICollectionView
//
//  Created by lhunath on 2014-03-27.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import "PearlUICollectionView.h"

@implementation PearlUICollectionView {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (!self.dragging)
        [self.nextResponder touchesBegan:touches withEvent:event];
    else
        [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    if (!self.dragging)
        [self.nextResponder touchesMoved:touches withEvent:event];
    else
        [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (!self.dragging)
        [self.nextResponder touchesEnded:touches withEvent:event];
    else
        [super touchesEnded:touches withEvent:event];
}

@end
