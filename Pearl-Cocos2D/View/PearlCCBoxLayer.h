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
//  PearlBoxView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCBoxLayer : CCNode {

    ccColor4B _color;
}

@property (nonatomic, assign) ccColor4B color;

+ (id)boxed:(CCNode *)node;
+ (id)boxed:(CCNode *)node color:(ccColor4B)color;
+ (instancetype)boxWithSize:(CGSize)aFrame at:(CGPoint)aLocation color:(ccColor4B)aColor;

- (id)initWithSize:(CGSize)aFrame at:(CGPoint)aLocation color:(ccColor4B)aColor;

@end
