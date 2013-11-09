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
//  PearlCCMenuItemBlock.h
//  Pearl
//
//  Created by Maarten Billemont on 08/06/11.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCMenuItemBlock : CCMenuItem

+ (instancetype)itemWithSize:(NSUInteger)size;
+ (instancetype)itemWithSize:(NSUInteger)size target:(id)target selector:(SEL)selector;

- (id)initWithSize:(NSUInteger)size target:(id)target selector:(SEL)selector;

@end
