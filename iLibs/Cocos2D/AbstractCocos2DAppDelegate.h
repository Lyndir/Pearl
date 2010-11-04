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
//  iLibs
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "AbstractAppDelegate.h"
#import "AudioController.h"
#import "UILayer.h"
#import "HUDLayer.h"
#import "ShadeLayer.h"


@interface AbstractCocos2DAppDelegate : AbstractAppDelegate {

    UILayer                                                  *_uiLayer;
    HUDLayer                                                 *_hudLayer;

    NSMutableArray                                           *_menuLayers;
}

@property (nonatomic, readonly, retain) UILayer             *uiLayer;
@property (nonatomic, readonly, retain) HUDLayer            *hudLayer;

- (void)hudMenuPressed;
- (void)pushLayer:(ShadeLayer *)layer;
- (void)pushLayer: (ShadeLayer *)layer hidden:(BOOL)hidden;
- (void)popAllLayers;
- (BOOL)isLastLayerShowing;
- (BOOL)isAnyLayerShowing;
- (void)popLayer;
- (void)poppedAll;
- (void)cleanup;
- (void)shutdown:(id)caller;

- (void)revealHud;
- (void)hideHud;

+(AbstractCocos2DAppDelegate *) get;


@end

