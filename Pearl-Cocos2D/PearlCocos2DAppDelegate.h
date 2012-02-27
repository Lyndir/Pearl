/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
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


@interface PearlCocos2DAppDelegate : PearlAppDelegate {

    PearlCCUILayer *_uiLayer;
    PearlCCHUDLayer *_hudLayer;

    NSMutableArray                                           *_menuLayers;
}

@property (nonatomic, readonly, retain) PearlCCUILayer *uiLayer;
@property (nonatomic, readonly, retain) PearlCCHUDLayer *hudLayer;

- (void)hudMenuPressed;
- (void)pushLayer:(PearlCCShadeLayer *)layer;
- (void)pushLayer: (PearlCCShadeLayer *)layer hidden:(BOOL)hidden;
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

+(PearlCocos2DAppDelegate *) get;


@end

