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
//  PearlCCUILayer.h
//  Pearl
//
//  Created by Maarten Billemont on 08/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCUILayer : CCLayerColor {

    CCLabelTTF     *_messageLabel;
    NSMutableArray *_messageQueue, *_callbackQueue;

    CCRotateTo *_rotateAction;
    UIAccelerationValue _accelX, _accelY, _accelZ;
}

//-(void) rotateTo:(float)aRotation;

- (void)message:(NSString *)msg;
- (void)message:(NSString *)msg callback:(id)target :(SEL)selector;

@end
