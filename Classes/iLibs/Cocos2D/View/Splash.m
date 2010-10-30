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
//  Splash.m
//  iLibs
//
//  Created by Maarten Billemont on 09/01/09.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "Splash.h"
#import "Config.h"
#import "AbstractCocos2DAppDelegate.h"
#import "BarSprite.h"


@interface SplashTransition : CCTransitionZoomFlipY

@end

@implementation SplashTransition

- (id)initWithGameScene:(CCScene *)uiScene {

    if (!(self = [super initWithDuration:[[Config get].transitionDuration floatValue]
                                   scene:uiScene
                             orientation:kOrientationDownOver]))
        return nil;
    
    return self;
}


@end


@interface Splash ()

- (void)switchScene;

@property (readwrite, assign) BOOL  switching;

@end


@implementation Splash

@synthesize switching = _switching;


-(id) init {
    
    if(!(self = [super init]))
        return self;
    
    self.texture            = [[CCTextureCache sharedTextureCache] addImage:@"splash.png"];
    self.textureRect        = CGRectFromPointAndSize(CGPointZero, self.texture.contentSize);
    self.position           = ccp([self contentSize].width / 2, [self contentSize].height / 2);
    
    BarSprite *loadingBar   = [[BarSprite alloc] initWithHead:@"aim.head.png" body:@"aim.body.%d.png" withFrames:16 tail:@"aim.tail.png" animatedTargetting:NO];
    loadingBar.position     = ccp(self.contentSize.width / 2 - 50, 40);
    loadingBar.target       = ccpAdd(loadingBar.position, ccp(100, 0));
    [self addChild:loadingBar];
    [loadingBar release];
    
    self.switching = NO;
    
    return self;
}


-(void) onEnter {
    
    [super onEnter];
    
    [self switchScene];
    //[self performSelector:@selector(switchScene) withObject:nil afterDelay:2];
}


-(void) switchScene {
    
    @synchronized(self) {
        if(self.switching)
            return;
        self.switching = YES;

        CCScene *uiScene = [CCScene new];
        [uiScene addChild:[AbstractCocos2DAppDelegate get].uiLayer];
        
        // Build a transition scene from the splash scene to the game scene.
        CCTransitionScene *transitionScene = [[SplashTransition alloc] initWithGameScene:uiScene];
        
        [uiScene release];
        
        // Start the scene and bring up the menu.
        [[CCDirector sharedDirector] replaceScene:transitionScene];
        [transitionScene release];
    }
}


@end
