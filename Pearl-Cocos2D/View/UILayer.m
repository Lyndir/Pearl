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
//  UILayer.m
//  Pearl
//
//  Created by Maarten Billemont on 08/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "UILayer.h"
#import "Remove.h"
#import "Config.h"
#import "CCDebug.h"

#define kFilteringFactor            0.4f
#define kAccelerometerFrequency     50 //Hz


@interface UILayer ()

-(void) resetMessage:(NSString *)msg;
- (void)popMessageQueue:(ccTime)dt;

@property (readwrite, retain) CCLabelTTF                                    *messageLabel;
@property (readwrite, retain) NSMutableArray                           *messageQueue;
@property (readwrite, retain) NSMutableArray                           *callbackQueue;

@property (readwrite, retain) CCRotateTo                                 *rotateAction;
@property (readwrite, assign) UIAccelerationValue                      accelX;
@property (readwrite, assign) UIAccelerationValue                      accelY;
@property (readwrite, assign) UIAccelerationValue                      accelZ;

@end


@implementation UILayer

@synthesize messageLabel = _messageLabel;
@synthesize messageQueue = _messageQueue, callbackQueue = _callbackQueue;
@synthesize rotateAction = _rotateAction;
@synthesize accelX = _accelX, accelY = _accelY, accelZ = _accelZ;


-(id) init {
#ifdef DEBUG
	if (!(self = [super initWithColor:ccc4(0xff, 0x00, 0x00, 0xff)]))
		return self;
#else
	if (!(self = [super initWithColor:ccc4(0x00, 0x00, 0x00, 0xff)]))
		return self;
#endif
    
    // Build internal structures.
    self.messageQueue = [NSMutableArray arrayWithCapacity:3];
    self.callbackQueue = [NSMutableArray arrayWithCapacity:3];
    
    //UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
    //theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;
    
    //[self schedule:@selector(debug:) interval:1];

    //self.isAccelerometerEnabled = YES;

    return self;
}

- (void)debug:(ccTime)delta {
    
    id sceneCandidate = self;
    while (![sceneCandidate isKindOfClass:[CCScene class]]) {
        sceneCandidate = [sceneCandidate parent];
        
        if (!sceneCandidate)
            // No scene in hierarchy.
            return;
    }
    
    [CCDebug printStateForScene:sceneCandidate];
}

/*
-(void) setRotation:(float)aRotation {
    
    [super setRotation:aRotation];
    
    NSUInteger barSide = (int)self.rotation / 90;
    if([CCDirector sharedDirector].deviceOrientation == CCDeviceOrientationLandscapeLeft)
        ++barSide;
    else if([CCDirector sharedDirector].deviceOrientation == CCDeviceOrientationLandscapeRight)
        --barSide;
    
    switch (barSide % 4) {
        case 0:
            //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            //break;
        case 1:
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            break;
        case 2:
            //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated:YES];
            //break;
        case 3:
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            break;
    }
}


-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // Use a basic low-pass filter to keep only the gravity component of each axis.
    self.accelX = (acceleration.x * kFilteringFactor) + (self.accelX * (1.0f - kFilteringFactor));
    self.accelY = (acceleration.y * kFilteringFactor) + (self.accelY * (1.0f - kFilteringFactor));
    self.accelZ = (acceleration.z * kFilteringFactor) + (self.accelZ * (1.0f - kFilteringFactor));
    
    // Use the acceleration data.
    if(self.accelX > 0.5)
        [self rotateTo:180];
    else if(self.accelX < -0.5)
        [self rotateTo:0];
}


-(void) rotateTo:(float)aRotation {
    
    if(self.rotateAction)
        [self stopAction:self.rotateAction];
    
    [self runAction:self.rotateAction = [CCRotateTo actionWithDuration:0.2f angle:aRotation]];
}*/


-(void) message:(NSString *)msg {
    
    [self message:msg callback:nil :nil];
}


-(void) message:(NSString *)msg callback:(id)target :(SEL)selector {
    
    NSInvocation *callback = nil;
    if(target) {
        NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:selector];
        callback = [NSInvocation invocationWithMethodSignature:signature];
        [callback setTarget:target];
        [callback setSelector:selector];
    }
    
    @synchronized(self.messageQueue) {
        [self.messageQueue insertObject:msg atIndex:0];
        [self.callbackQueue insertObject:callback? callback: (id)[NSNull null] atIndex:0];
        
        //if(![self isScheduled:@selector(popMessageQueue:)])
            [self schedule:@selector(popMessageQueue:)];
    }
}


-(void) popMessageQueue: (ccTime)dt {
    
    @synchronized(self.messageQueue) {
        [self unschedule:@selector(popMessageQueue:)];
        
        if(![self.messageQueue count])
            // No messages left, don't reschedule.
            return;
        
        [self schedule:@selector(popMessageQueue:) interval:1.5f];
    }
    
    NSString *msg = [[self.messageQueue lastObject] retain];
    [self.messageQueue removeLastObject];
    
    NSInvocation *callback = [[self.callbackQueue lastObject] retain];
    [self.callbackQueue removeLastObject];
    
    [self resetMessage:msg];
    [self.messageLabel runAction:[CCSequence actions:
                             [CCMoveBy actionWithDuration:1 position:ccp(0, -([[Config get].fontSize intValue] * 2))],
                             [CCFadeTo actionWithDuration:2 opacity:0x00],
                             nil]];
    
    if(callback != (id)[NSNull null])
        [callback invoke];
    
    [callback release];
    [msg release];
}


-(void) resetMessage:(NSString *)msg {
    
    if(!self.messageLabel || [self.messageLabel numberOfRunningActions]) {
        // Detach existing label & create a new message label for the next message.
        if(self.messageLabel) {
            [self.messageLabel stopAllActions];
            [self.messageLabel runAction:[CCSequence actions:
                                     [CCMoveTo actionWithDuration:1
                                                       position:ccp(-[self.messageLabel contentSize].width / 2, [self.messageLabel position].y)],
                                     [CCFadeOut actionWithDuration:1],
                                     [Remove action],
                                     nil]];
        }
        
        self.messageLabel = [CCLabelTTF labelWithString:msg
                                          fontName:[Config get].fixedFontName
                                          fontSize:[[Config get].fontSize intValue]];
        [self addChild: self.messageLabel z:1];
    }
    else
        [self.messageLabel setString:msg];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [self.messageLabel setPosition:ccp([self.messageLabel contentSize].width / 2 + [[Config get].fontSize intValue],
                                  winSize.height + [[Config get].fontSize intValue])];
    [self.messageLabel setOpacity:0xff];
}


-(void) dealloc {
    
    self.rotateAction = nil;
    self.messageQueue = nil;
    self.callbackQueue = nil;
    self.messageLabel = nil;
    
    [super dealloc];
}


@end
