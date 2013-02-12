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
//  PearlCCFlickLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 22/10/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCScrollLayer.h"


@interface PearlCCFlickLayer : CCLayer<PearlCCScrollLayerDelegate> {

    PearlCCScrollLayer *_content;

    CCMenuItem *_right, *_left;
}

+ (instancetype)flickSprites:(CCSprite *)firstSprite, ... NS_REQUIRES_NIL_TERMINATION;
+ (instancetype)flickSpritesFromArray:(NSArray *)sprites;

- (id)initWithSprites:(CCSprite *)firstSprite, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithSpritesFromArray:(NSArray *)sprites;

@end
