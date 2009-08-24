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
//  iLibs
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "AbstractAppDelegate.h"
#import "Splash.h"
#import "Resettable.h"
#import "DebugLayer.h"
#import "ShadeLayer.h"

@interface Director (Reveal)

-(void) startAnimation;

@end


@implementation AbstractAppDelegate

@synthesize uiLayer;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	// Init the window.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
    [window makeKeyAndVisible];

	// Director and OpenGL Setup.
    [Director useFastDirector];
#if TARGET_IPHONE_SIMULATOR
    [[Director sharedDirector] setPixelFormat:kRGBA8];
#else
    //[[Director sharedDirector] setDisplayFPS:YES];
#endif
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[Director sharedDirector] attachInWindow:window];
	[[Director sharedDirector] setDepthTest:NO];
    
    // Random seed with timestamp.
    srandom(time(nil));
    
    // Menu items font.
    [MenuItemFont setFontSize:[[Config get].fontSize intValue]];
    [MenuItemFont setFontName:[Config get].fontName];
    menuLayers = [[NSMutableArray alloc] initWithCapacity:3];

	// Build the splash scene.
    Scene *splashScene = [Scene node];
    Sprite *splash = [Splash node];
    [splashScene addChild:splash];
    
    // Build the game scene.
    uiLayer = [[UILayer alloc] init];
    DebugLayer *debugLayer = [DebugLayer node];
    [uiLayer addChild:debugLayer z:99];
	
    // Start the background music.
    [[AudioController get] playTrack:[Config get].currentTrack];
    
    [self revealHud];
    [self hideHud];
    
    [self prepareUi];

    // Show the splash screen, this starts the main loop in the current thread.
    [[Director sharedDirector] pushScene:splashScene];
    do {
#if ! TARGET_IPHONE_SIMULATOR
        @try {
#endif
            [[Director sharedDirector] startAnimation];
#if ! TARGET_IPHONE_SIMULATOR
        }
        @catch (NSException * e) {
            NSLog(@"=== Exception Occurred! ===");
            NSLog(@"Name: %@; Reason: %@; Context: %@.\n", [e name], [e reason], [e userInfo]);
            [hudLayer message:[e reason] duration:5 isImportant:YES];
        }
#endif
    } while ([[Director sharedDirector] runningScene]);
}


- (void)prepareUi {
    
    [NSException raise:NSInternalInconsistencyException format:@"Override me!"]; 
}


- (void)hudMenuPressed {
    
    [NSException raise:NSInternalInconsistencyException format:@"Override me!"]; 
}


-(void) revealHud {
    
    if(hudLayer) {
        if(![hudLayer dismissed])
            // Already showing and not dismissed.
            return;
    
        if([hudLayer parent])
            // Already showing and being dismissed.
            [uiLayer removeChild:hudLayer cleanup:YES];
    }

    [uiLayer addChild:[self hudLayer]];
}


-(void) hideHud {
    
    [hudLayer dismiss];
}


-(HUDLayer *) hudLayer {
    
    if(!hudLayer)
        hudLayer = [[HUDLayer alloc] init];
    
    return hudLayer;
}


-(void) updateConfig {

}


-(void) popLayer {

    [(ShadeLayer *) [menuLayers lastObject] dismissAsPush:NO];
    [menuLayers removeLastObject];
    if([menuLayers count])
        [uiLayer addChild:[menuLayers lastObject]];
    else
        [self poppedAll];
}


- (void)poppedAll {
    
}


-(void) popAllLayers {
    
    if(![menuLayers count])
        return;

    id last = [menuLayers lastObject];
    [menuLayers makeObjectsPerformSelector:@selector(dismissAsPush:) withObject:NO];
    [menuLayers removeAllObjects];
    [menuLayers addObject:last];

    [self popLayer];
}


-(void) pushLayer: (ShadeLayer *)layer {
    
    if(layer.parent) {
        if (![menuLayers containsObject:layer])
            // Layer is showing but shouldn't have been; probably being dismissed.
            [uiLayer removeChild:layer cleanup:YES];
        
        else {
            // Layer is already showing.
            if ([layer conformsToProtocol:@protocol(Resettable)])
                [(ShadeLayer<Resettable> *) layer reset];
        
            return;
        }
    }

    [(ShadeLayer *) [menuLayers lastObject] dismissAsPush:YES];
    [menuLayers addObject:layer];
    [uiLayer addChild:layer];
}


-(void) applicationWillResignActive:(UIApplication *)application {
    
    [[Director sharedDirector] pause];
}


-(void) applicationDidBecomeActive:(UIApplication *)application {

    [[Director sharedDirector] resume];
}


-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
	[[TextureMgr sharedTextureMgr] removeAllTextures];
    
    [self cleanup];
}


-(void) cleanup {
    
    if(hudLayer && ![hudLayer parent]) {
        [hudLayer stopAllActions];
        [hudLayer release];
        hudLayer = nil;
    }

    [[AudioController get] playTrack:nil];
}


- (void)dealloc {
    
    [uiLayer release];
    uiLayer = nil;
    
    [menuLayers release];
    menuLayers = nil;
    
    [hudLayer release];
    hudLayer = nil;
    
    [window release];
    window = nil;
    
    [super dealloc];
}


+(AbstractAppDelegate *) get {
    
    return (AbstractAppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
