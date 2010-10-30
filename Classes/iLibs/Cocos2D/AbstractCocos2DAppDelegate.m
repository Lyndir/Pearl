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

#import "AbstractCocos2DAppDelegate.h"
#import "Config.h"
#import "Splash.h"
#import "Resettable.h"
#import "DebugLayer.h"
#import "ShadeLayer.h"

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
    UIWindow *window;
    CC_DIRECTOR_INIT();
    self.window = [window autorelease];
#if TARGET_IPHONE_SIMULATOR
    //FIXME? [[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
#else
    //[[CCDirector sharedDirector] setDisplayFPS:YES];
#endif
    
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
        _hudLayer = [[HUDLayer alloc] init];
    
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
}

- (void)shutdown:(id)caller {
    
    [[CCDirector sharedDirector] end];
    [[CCDirector sharedDirector] release];
}

-(void) applicationWillResignActive:(UIApplication *)application {
    
    [[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application {

    [[CCDirector sharedDirector] resume];
}

-(void) cleanup {
    
	[[CCTextureCache sharedTextureCache] removeAllTextures];
    
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
    
    [super dealloc];
}


+(AbstractAppDelegate *) get {
    
    return (AbstractAppDelegate *) [[UIApplication sharedApplication] delegate];
}


@end
