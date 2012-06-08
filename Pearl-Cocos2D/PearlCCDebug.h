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
//  PearlCCDebug.h
//  Deblock
//
//  Created by Maarten Billemont on 03/04/11.
//  Copyright 2011 Lhunath. All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCDebug : NSObject {

}

+ (void)printStateForScene:(CCScene *)scene;
+ (void)printStateForNode:(CCNode *)node indent:(NSUInteger)indent;
+ (NSString *)describe:(CCNode *)node;

@end
