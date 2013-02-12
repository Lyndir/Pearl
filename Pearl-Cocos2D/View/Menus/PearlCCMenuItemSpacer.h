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
//  PearlCCMenuItemSpacer.h
//  Pearl
//
//  Created by Maarten Billemont on 02/03/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"

@interface PearlCCMenuItemSpacer : CCMenuItem {

    CGFloat _height;
}

+ (instancetype)spacerSmall;
+ (instancetype)spacerNormal;
+ (instancetype)spacerLarge;

- (id)initSmall;
- (id)initNormal;
- (id)initLarge;

- (id)initWithHeight:(CGFloat)_height;

@end
