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
//  PearlCCShadeLayer.h
//  Pearl
//
//  Created by Maarten Billemont on 26/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCFancyLayer.h"


@interface PearlCCShadeLayer : PearlCCFancyLayer {

    BOOL                                                    _pushed;
    BOOL                                                    _fadeNextEntry;
    CCMenuItem                                              *_backButton, *_nextButton, *_defaultBackButton, *_defaultNextButton;
    CCMenu                                                  *_backMenu, *_nextMenu;
    NSInvocation                                            *_backInvocation, *_nextInvocation;

    CCNode                                                  *_background;
    CGPoint                                                 _backgroundOffset;
}

@property (nonatomic, readonly, assign) BOOL                pushed;
@property (nonatomic, readwrite, retain) CCMenuItem         *backButton;
@property (nonatomic, readwrite, retain) CCMenuItem         *nextButton;
@property (nonatomic, readwrite, retain) CCMenuItem         *defaultBackButton;
@property (nonatomic, readwrite, retain) CCMenuItem         *defaultNextButton;
@property (nonatomic, readwrite) BOOL                       fadeNextEntry;
@property (nonatomic, readwrite, retain) CCNode             *background;
@property (nonatomic, readwrite, assign) CGPoint            backgroundOffset;

- (void)setBackButtonTarget:(id)target selector:(SEL)selector;
- (void)setNextButtonTarget:(id)target selector:(SEL)selector;
- (void)dismissAsPush:(BOOL)isPushed;
- (void)back;

- (void)ready;
- (void)gone;

- (void)enterAction;
- (void)dismissAction;

@end
