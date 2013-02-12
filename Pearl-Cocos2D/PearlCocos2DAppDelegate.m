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
//  AbstractAppDelegate.m
//  Pearl
//
//  Created by Maarten Billemont on 18/10/08.
//  Copyright, lhunath (Maarten Billemont) 2008. All rights reserved.
//

#import "PearlCocos2DAppDelegate.h"
#import "PearlConfig.h"
#import "PearlCCSplash.h"
#import "PearlResettable.h"
#import "PearlCCDebugLayer.h"
#import "PearlCCShadeLayer.h"
#import "PearlDeviceUtils.h"

@interface CCDirector ()

- (void)startAnimation;

@end


@interface PearlCocos2DAppDelegate ()

@property (nonatomic, readwrite, retain) PearlCCUILayer  *uiLayer;
@property (nonatomic, readwrite, retain) PearlCCHUDLayer *hudLayer;

@property (readwrite, retain) NSMutableArray *menuLayers;

@end


@implementation PearlCocos2DAppDelegate

@synthesize uiLayer = _uiLayer;
@synthesize hudLayer = _hudLayer;
@synthesize menuLayers = _menuLayers;


- (void)preSetup {

    [super preSetup];

    // Init the window.
#ifdef DEBUG
    [CCDirector sharedDirector].displayStats = YES;
#endif
    [CCDirector sharedDirector].view     = [CCGLView viewWithFrame:self.window.rootViewController.view.frame
                                                       pixelFormat:kEAGLColorFormatRGBA8];
    [CCDirector sharedDirector].delegate = self;
    if (![[CCDirector sharedDirector] enableRetinaDisplay:YES])
    dbg(@"Not a retina device");
//    [CCFileUtils sharedFileUtils].enableFallbackSuffixes = YES;

    self.window.rootViewController = [CCDirector sharedDirector];
    [self.window makeKeyAndVisible];

    // Random seed with timestamp.
    srandom((unsigned int)time(nil));

    // CCMenu items font.
    [CCMenuItemFont setFontSize:[[PearlConfig get].fontSize unsignedIntegerValue]];
    [CCMenuItemFont setFontName:[PearlConfig get].fontName];
    self.menuLayers = [NSMutableArray arrayWithCapacity:3];

    // Build the game scene.
    self.uiLayer = [PearlCCUILayer node];
#ifdef DEBUG
    [self.uiLayer addChild:[PearlCCDebugLayer get] z:99];
#endif
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)hudMenuPressed {

    [NSException raise:NSInternalInconsistencyException format:@"Override me!"];
}

- (void)revealHud {

    if (![self.hudLayer dismissed])
     // Already showing and not dismissed.
        return;

    if (![self.hudLayer parent])
        [self.uiLayer addChild:self.hudLayer z:1];

    [self.hudLayer reveal];
}

- (void)hideHud {

    [self.hudLayer dismiss];
}

- (PearlCCHUDLayer *)hudLayer {

    if (!_hudLayer)
        _hudLayer = [[PearlCCHUDLayer alloc] init];

    return _hudLayer;
}

- (BOOL)isLastLayerShowing {

    return [self.menuLayers count] == 1;
}

- (BOOL)isLayerShowing:(PearlCCShadeLayer *)layer {

    return layer && [self peekLayer] == layer;
}

- (BOOL)isAnyLayerShowing {

    return [self.menuLayers count] > 0;
}

- (PearlCCShadeLayer *)peekLayer {

    return [self.menuLayers lastObject];
}

- (void)popLayer {

    PearlCCShadeLayer *layer = [self.menuLayers lastObject];
    [layer dismissAsPush:NO];
    [self.menuLayers removeLastObject];

    BOOL anyLeft = [self isAnyLayerShowing];
    if (anyLeft) {
        PearlCCShadeLayer *newLayer = [self.menuLayers lastObject];
        [newLayer stopAllActions];
        [newLayer removeFromParentAndCleanup:YES];
        [self.uiLayer addChild:newLayer];
    }

    [self didPopLayer:layer anyLeft:anyLeft];
}

- (void)didPopLayer:(PearlCCShadeLayer *)layer anyLeft:(BOOL)anyLeft {

    if (!anyLeft)
        [self revealHud];
}

- (void)popAllLayers {

    if (![self.menuLayers count])
        return;

    id last = [self.menuLayers lastObject];
    [self.menuLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj dismissAsPush:NO];
    }];
    [self.menuLayers removeAllObjects];
    [self.menuLayers addObject:last];

    [self popLayer];
}

- (void)pushLayer:(PearlCCShadeLayer *)layer {

    [self pushLayer:layer hidden:NO];
}

- (void)pushLayer:(PearlCCShadeLayer *)layer hidden:(BOOL)hidden {

    if (layer.parent) {
        if (![self.menuLayers containsObject:layer])
         // CCLayer is showing but shouldn't have been; probably being dismissed.
            [self.uiLayer removeChild:layer cleanup:YES];

        else {
            // CCLayer is already showing.
            if ([layer conformsToProtocol:@protocol(PearlResettable)])
                [(PearlCCShadeLayer<PearlResettable> *)layer reset];

            return;
        }
    }

    [(PearlCCShadeLayer *)[self.menuLayers lastObject] dismissAsPush:YES];
    [self.menuLayers addObject:layer];
    [self.uiLayer addChild:layer];
    layer.visible = !hidden;

    [self hideHud];
    [self didPushLayer:layer hidden:hidden];
}

- (void)didPushLayer:(PearlCCShadeLayer *)layer hidden:(BOOL)hidden {

}

- (void)shutdown:(id)caller {

    [[CCDirector sharedDirector] end];
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [super applicationWillResignActive:application];

    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [super applicationDidBecomeActive:application];

    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {

    [super applicationDidReceiveMemoryWarning:application];

    if (self.hudLayer && ![self.hudLayer parent]) {
        [self.hudLayer stopAllActions];
        self.hudLayer = nil;
    }

    [[CCDirector sharedDirector] purgeCachedData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [super applicationDidEnterBackground:application];

    [[CCDirector sharedDirector] stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

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

@end
