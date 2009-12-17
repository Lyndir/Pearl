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

@interface Director ()

-(void) startAnimation;

@end


@interface AbstractAppDelegate ()

@property (nonatomic, readwrite, retain) UIWindow                                                 *window;

@property (nonatomic, readwrite, retain) UILayer                                                  *uiLayer;

@property (readwrite, retain) NSMutableArray                                           *menuLayers;

@end


@implementation AbstractAppDelegate

@synthesize window = _window;
@synthesize uiLayer = _uiLayer;
@synthesize hudLayer = _hudLayer;
@synthesize menuLayers = _menuLayers;



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
        [[Logger get] inf:@"%@", copyright];
    [[Logger get] inf:@"==================================="];
    
	// Init the window.
	self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	[self.window setUserInteractionEnabled:YES];

	// Director and OpenGL Setup.
    //[Director useFastDirector];
#if TARGET_IPHONE_SIMULATOR
    [[Director sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
#else
    //[[Director sharedDirector] setDisplayFPS:YES];
#endif
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    [[Director sharedDirector] attachInView:self.window];
    
    // Random seed with timestamp.
    srandom(time(nil));
    
    // Menu items font.
    [MenuItemFont setFontSize:[[Config get].fontSize intValue]];
    [MenuItemFont setFontName:[Config get].fontName];
    self.menuLayers = [NSMutableArray arrayWithCapacity:3];

    // Build the game scene.
    self.uiLayer = [UILayer node];
    [self.uiLayer addChild:[DebugLayer get] z:99];
	
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
    
    if(self.hudLayer) {
        if(![self.hudLayer dismissed])
            // Already showing and not dismissed.
            return;
    
        if([self.hudLayer parent])
            // Already showing and being dismissed.
            [self.uiLayer removeChild:self.hudLayer cleanup:YES];
    }

    [self.uiLayer addChild:self.hudLayer];
}


- (void)hideHud {
    
    [self.hudLayer dismiss];
}


- (HUDLayer *)hudLayer {
    
    if(!_hudLayer)
        self.hudLayer = [HUDLayer node];
    
    return _hudLayer;
}


- (void)didUpdateConfigForKey:(SEL)configKey {

}


- (void)popLayer {

    [(ShadeLayer *) [self.menuLayers lastObject] dismissAsPush:NO];
    [self.menuLayers removeLastObject];
    if([self isAnyLayerShowing])
        [self.uiLayer addChild:[self.menuLayers lastObject]]; // FIXME: double tap back breaks me.
    else
        [self poppedAll];
}

- (BOOL)isLastLayerShowing {
    
    return [self.menuLayers count] == 1;
}

- (BOOL)isAnyLayerShowing {
    
    return [self.menuLayers count];
}

- (void)poppedAll {
    
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
            // Layer is showing but shouldn't have been; probably being dismissed.
            [self.uiLayer removeChild:layer cleanup:YES];
        
        else {
            // Layer is already showing.
            if ([layer conformsToProtocol:@protocol(Resettable)])
                [(ShadeLayer<Resettable> *) layer reset];
        
            return;
        }
    }

    [(ShadeLayer *) [self.menuLayers lastObject] dismissAsPush:YES];
    [self.menuLayers addObject:layer];
    [self.uiLayer addChild:layer];
    layer.visible = !hidden;
}

- (void)shutdown:(id)caller {
    
    [[Director sharedDirector] end];
    [[Director sharedDirector] release];
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
    
    if(self.hudLayer && ![self.hudLayer parent]) {
        [self.hudLayer stopAllActions];
        self.hudLayer = nil;
    }

    [[AudioController get] playTrack:nil];
}


- (void)dealloc {
    
    self.uiLayer = nil;
    self.menuLayers = nil;
    self.hudLayer = nil;
    self.window = nil;
    
    [super dealloc];
}


+(AbstractAppDelegate *) get {
    
    return (AbstractAppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
