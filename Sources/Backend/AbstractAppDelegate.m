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
    
    // Log application details.
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleName"];
    NSString *displayName = [info objectForKey:@"CFBundleDisplayName"];
    NSString *build = [info objectForKey:@"CFBundleVersion"];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *copyright = [info objectForKey:@"NSHumanReadableCopyright"];
    
    if (!name)
        name = displayName;
    if (displayName && ![displayName isEqualToString:name])
        name = [NSString stringWithFormat:@"%@ (%@)", displayName, name];
    if (!version)
        version = build;
    if (build && ![build isEqualToString:version])
        version = [NSString stringWithFormat:@"%@ (%@)", version, build];
    
    [[Logger get] inf:@"%@ v%@", name, version];
    if (copyright)
        [[Logger get] inf:@"Copyright %@", copyright];
    [[Logger get] inf:@"====================================="];
    
	// Init the window.
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	[window setUserInteractionEnabled:YES];

	// Director and OpenGL Setup.
    //[Director useFastDirector];
#if TARGET_IPHONE_SIMULATOR
    [[Director sharedDirector] setPixelFormat:kRGBA8];
#else
    //[[Director sharedDirector] setDisplayFPS:YES];
#endif
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    [[Director sharedDirector] attachInView:window];
    
    // Random seed with timestamp.
    srandom(time(nil));
    
    // Menu items font.
    [MenuItemFont setFontSize:[[Config get].fontSize intValue]];
    [MenuItemFont setFontName:[Config get].fontName];
    menuLayers = [[NSMutableArray alloc] initWithCapacity:3];

    // Build the game scene.
    uiLayer = [[UILayer alloc] init];
    [uiLayer addChild:[DebugLayer get] z:99];
	
    // Start the background music.
    [[AudioController get] playTrack:[Config get].currentTrack];
    
    [self revealHud];
    [self hideHud];
    
    [self prepareUi];
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


- (void)didUpdateConfigForKey:(SEL)configKey {

}


- (void)popLayer {

    [(ShadeLayer *) [menuLayers lastObject] dismissAsPush:NO];
    [menuLayers removeLastObject];
    if([self isAnyLayerShowing])
        [uiLayer addChild:[menuLayers lastObject]];
    else
        [self poppedAll];
}

- (BOOL)isLastLayerShowing {
    
    return [menuLayers count] == 1;
}

- (BOOL)isAnyLayerShowing {
    
    return [menuLayers count];
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

- (void)pushLayer: (ShadeLayer *)layer {
    
    [self pushLayer:layer hidden:NO];
}


- (void)pushLayer: (ShadeLayer *)layer hidden:(BOOL)hidden {
    
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
    layer.visible = !hidden;
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

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [Config get].firstRun = [NSNumber numberWithBool:NO];
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
