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
//  PearlCCBarLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 05/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "cocos2d.h"


@interface PearlCCBarLayer : CCSprite {

    CCMenuItemAtlasFont *_menuButton;
    CCMenu              *_menuMenu;
    CCLabelTTF          *_messageLabel;

    NSUInteger _textColor, _renderColor;
    CGPoint    _showPosition;

    BOOL _dismissed;
}

@property (nonatomic, readonly) BOOL dismissed;

+ (instancetype)barWithColor:(NSUInteger)aColor position:(CGPoint)aShowPosition;
- (id)initWithColor:(NSUInteger)aColor position:(CGPoint)aShowPosition;

- (void)setButtonTitle:(NSString *)aTitle callback:(id)target :(SEL)selector;
- (CGPoint)hidePosition;
- (void)reveal;
- (void)dismiss;

- (void)message:(NSString *)msg isImportant:(BOOL)important;
- (void)message:(NSString *)msg duration:(ccTime)_duration isImportant:(BOOL)important;
- (void)dismissMessage;

@end
