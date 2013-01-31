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
//  AbstractAppDelegate.h
//  Pearl
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "PearlAppDelegate.h"
#import "PearlCCUILayer.h"
#import "PearlCCHUDLayer.h"
#import "PearlCCShadeLayer.h"


@interface PearlCocos2DAppDelegate : PearlAppDelegate<CCDirectorDelegate> {

    PearlCCUILayer  *_uiLayer;
    PearlCCHUDLayer *_hudLayer;

    NSMutableArray *_menuLayers;
}

@property (nonatomic, readonly, retain) PearlCCUILayer  *uiLayer;
@property (nonatomic, readonly, retain) PearlCCHUDLayer *hudLayer;

- (void)hudMenuPressed;
- (void)pushLayer:(PearlCCShadeLayer *)layer;
- (void)pushLayer:(PearlCCShadeLayer *)layer hidden:(BOOL)hidden;
- (void)popAllLayers;
- (BOOL)isLastLayerShowing;
- (BOOL)isLayerShowing:(PearlCCShadeLayer *)layer;
- (BOOL)isAnyLayerShowing;
- (PearlCCShadeLayer *)peekLayer;
- (void)popLayer;
- (void)didPopLayer:(PearlCCShadeLayer *)layer anyLeft:(BOOL)anyLeft;
- (void)didPushLayer:(PearlCCShadeLayer *)layer hidden:(BOOL)hidden;
- (void)shutdown:(id)caller;

- (void)revealHud;
- (void)hideHud;

@end

