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
//  PearlFixedTableView
//
//  Created by Maarten Billemont on 2014-05-26.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlFixedTableView.h"

@implementation PearlFixedTableView

- (CGSize)intrinsicContentSize {

    return CGSizeMake( UIViewNoIntrinsicMetric, self.contentSize.height );
}

- (void)setBounds:(CGRect)bounds {

    [super setBounds:bounds];

    if (!self.scrollEnabled & (self.scrollEnabled = self.bounds.size.height < self.contentSize.height))
        [self flashScrollIndicators];
}

- (void)setContentSize:(CGSize)contentSize {

    [super setContentSize:contentSize];

    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)endUpdates {

    [super endUpdates];

    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)reloadData {

    [super reloadData];

    [self invalidateIntrinsicContentSize];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

@end
