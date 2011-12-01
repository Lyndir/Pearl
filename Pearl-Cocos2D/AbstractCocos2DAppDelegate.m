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
//  AbstractAppDelegate.m
//  Pearl
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "AbstractCocos2DAppDelegate.h"
#import "Config.h"
#import "Splash.h"
#import "Resettable.h"
#import "DebugLayer.h"
#import "ShadeLayer.h"
#import "DeviceUtils.h"

@interface CCDirector ()

-(void) startAnimation;

@end


@interface AbstractCocos2DAppDelegate ()

@property (nonatomic, readwrite, retain) UILayer            *uiLayer;
@property (nonatomic, readwrite, retain) HUDLayer           *hudLayer;

@property (readwrite, retain) NSMutableArray                *menuLayers;

@end


@implementation AbstractCocos2DAppDelegate

@synthesize uiLayer = _uiLayer;
@synthesize hudLayer = _hudLayer;
@synthesize menuLayers = _menuLayers;


- (void)preSetup {

    [super preSetup];

	// Init the window.
	if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];
    [CCDirector sharedDirector].contentScaleFactor = [UIScreen mainScreen].scale;
    if ([DeviceUtils isIPad] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        // An iPad in iPhone compatibility mode.
        [CCDirector sharedDirector].contentScaleFactor *= 2;
#if DEBUG
    [CCDirector sharedDirector].displayFPS          = YES;
#endif
	[CCDirector sharedDirector].openGLView          = [EAGLView viewWithFrame:self.window.rootViewController.view.frame
                                                                  pixelFormat:kEAGLColorFormatRGBA8];

    //self.window.rootViewController.view.hidden = YES;
    [self.window.rootViewController.view addSubview:[CCDirector sharedDirector].openGLView];
	[self.window makeKeyAndVisible];

    // Random seed with timestamp.
    srandom(time(nil));

    // CCMenu items font.
    [CCMenuItemFont setFontSize:[[Config get].fontSize intValue]];
    [CCMenuItemFont setFontName:[Config get].fontName];
    self.menuLayers = [NSMutableArray arrayWithCapacity:3];

    // Build the game scene.
    self.uiLayer = [UILayer node];
    [self.uiLayer addChild:[DebugLayer get] z:99];

    [self revealHud];
    [self hideHud];
}

- (void)onCrash {

    [[CCDirector sharedDirector] end];
    [super onCrash];
}

- (void)hudMenuPressed {

    [NSException raise:NSInternalInconsistencyException format:@"Override me!"];
}

-(void) revealHud {

    if(![self.hudLayer dismissed])
        // Already showing and not dismissed.
        return;

    if(![self.hudLayer parent])
        [self.uiLayer addChild:self.hudLayer z:1];

    [self.hudLayer reveal];
}

- (void)hideHud {

    [self.hudLayer dismiss];
}

- (HUDLayer *)hudLayer {

    if(!_hudLayer)
        _hudLayer = [[HUDLayer alloc] init];

    return _hudLayer;
}

- (BOOL)isLastLayerShowing {

    return [self.menuLayers count] == 1;
}

- (BOOL)isLayerShowing:(ShadeLayer *)layer {

    return layer && [self peekLayer] == layer;
}

- (BOOL)isAnyLayerShowing {

    return [self.menuLayers count];
}

- (ShadeLayer *)peekLayer {

    return [self.menuLayers lastObject];
}

- (void)popLayer {

    ShadeLayer *layer = [self.menuLayers lastObject];
    [layer dismissAsPush:NO];
    [self.menuLayers removeLastObject];

    BOOL anyLeft = [self isAnyLayerShowing];
    if(anyLeft) {
        ShadeLayer *newLayer = [self.menuLayers lastObject];
        [newLayer stopAllActions];
        [newLayer removeFromParentAndCleanup:YES];
        [self.uiLayer addChild:newLayer];
    }

    [self didPopLayer:layer anyLeft:anyLeft];
}

- (void)didPopLayer:(ShadeLayer *)layer anyLeft:(BOOL)anyLeft {

    if (!anyLeft)
        [self revealHud];
}

-(void) popAllLayers {

    if(![self.menuLayers count])
        return;

    id last = [self.menuLayers lastObject];
    [self.menuLayers makeObjectsPerformSelector:@selector(dismissAsPush:) withObject:NO];
    [self.menuLayers removeAllObjects];
    [self.menuLayers addObject:last];

    [self popLayer];
}

- (void)pushLayer: (ShadeLayer *)layer {

    [self pushLayer:layer hidden:NO];
}

- (void)pushLayer: (ShadeLayer *)layer hidden:(BOOL)hidden {

    if(layer.parent) {
        if (![self.menuLayers containsObject:layer])
            // CCLayer is showing but shouldn't have been; probably being dismissed.
            [self.uiLayer removeChild:layer cleanup:YES];

        else {
            // CCLayer is already showing.
            if ([layer conformsToProtocol:@protocol(Resettable)])
                [(ShadeLayer<Resettable> *) layer reset];

            return;
        }
    }

    [(ShadeLayer *) [self.menuLayers lastObject] dismissAsPush:YES];
    [self.menuLayers addObject:layer];
    [self.uiLayer addChild:layer];
    layer.visible = !hidden;

    [self hideHud];
    [self didPushLayer:layer hidden:hidden];
}

- (void)didPushLayer:(ShadeLayer *)layer hidden:(BOOL)hidden {

}

- (void)shutdown:(id)caller {

    [[CCDirector sharedDirector] end];
    [[CCDirector sharedDirector] release];
}

-(void) applicationWillResignActive:(UIApplication *)application {

    [super applicationWillResignActive:application];

    [[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application {

    [super applicationDidBecomeActive:application];

    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

    [super applicationDidReceiveMemoryWarning:application];

    if(self.hudLayer && ![self.hudLayer parent]) {
        [self.hudLayer stopAllActions];
        self.hudLayer = nil;
    }

	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {

    [super applicationDidEnterBackground:application];

    [[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {

    [super applicationWillEnterForeground:application];

	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {

    [super applicationWillTerminate:application];

	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {

    [super applicationSignificantTimeChange:application];

	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {

    self.uiLayer = nil;
    self.menuLayers = nil;
    self.hudLayer = nil;

    [super dealloc];
}


+(AbstractAppDelegate *) get {

    return (AbstractAppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
