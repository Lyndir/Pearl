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
//  PearlCCHUDLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 10/11/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCBarLayer.h"


@interface PearlCCHUDLayer : PearlCCBarLayer<PearlResettable> {

    CCLabelAtlas    *_scoreSprite;
    CCLabelAtlas    *_scoreCount;
    PearlCCBarLayer *_messageBar;
}

@property (nonatomic, readonly, retain) CCLabelAtlas    *scoreSprite;
@property (nonatomic, readonly, retain) CCLabelAtlas    *scoreCount;
@property (nonatomic, readonly, retain) PearlCCBarLayer *messageBar;

- (BOOL)hitsHud:(CGPoint)pos;
- (void)highlightGood:(BOOL)wasGood;
- (int64_t)score;

@end
