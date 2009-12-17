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
//  iLibs
//
//  Created by Maarten Billemont on 08/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "UILayer.h"
#import "Remove.h"
#define kFilteringFactor            0.4f
#define kAccelerometerFrequency     50 //Hz


@interface UILayer (Private)

-(void) resetMessage:(NSString *)msg;
- (void)popMessageQueue:(ccTime)dt;

@end


@implementation UILayer


-(id) init {
    
	if (!(self = [super initWithColor:ccc4(0xff, 0x00, 0x00, 0xff)]))
		return self;
    
    // Build internal structures.
    messageQueue = [[NSMutableArray alloc] initWithCapacity:3];
    callbackQueue = [[NSMutableArray alloc] initWithCapacity:3];
    messageLabel = nil;
    
    //UIAccelerometer*  theAccelerometer = [UIAccelerometer sharedAccelerometer];
    //theAccelerometer.updateInterval = 1 / kAccelerometerFrequency;

    isAccelerometerEnabled = YES;

    return self;
}


-(void) setRotation:(float)aRotation {
    
    [super setRotation:aRotation];
    
    NSUInteger barSide = (int)self.rotation / 90;
    if([Director sharedDirector].deviceOrientation == CCDeviceOrientationLandscapeLeft)
        ++barSide;
    else if([Director sharedDirector].deviceOrientation == CCDeviceOrientationLandscapeRight)
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
    accelX = (acceleration.x * kFilteringFactor) + (accelX * (1.0f - kFilteringFactor));
    accelY = (acceleration.y * kFilteringFactor) + (accelY * (1.0f - kFilteringFactor));
    accelZ = (acceleration.z * kFilteringFactor) + (accelZ * (1.0f - kFilteringFactor));
    
    // Use the acceleration data.
    if(accelX > 0.5)
        [self rotateTo:180];
    else if(accelX < -0.5)
        [self rotateTo:0];
}


-(void) rotateTo:(float)aRotation {
    
    if(rotateAction) {
        [self stopAction:rotateAction];
        [rotateAction release];
    }
    
    [self runAction:rotateAction = [[RotateTo alloc] initWithDuration:0.2f angle:aRotation]];
}


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
    
    @synchronized(messageQueue) {
        [messageQueue insertObject:msg atIndex:0];
        [callbackQueue insertObject:callback? callback: (id)[NSNull null] atIndex:0];
        
        //if(![self isScheduled:@selector(popMessageQueue:)])
            [self schedule:@selector(popMessageQueue:)];
    }
}


-(void) popMessageQueue: (ccTime)dt {
    
    @synchronized(messageQueue) {
        [self unschedule:@selector(popMessageQueue:)];
        
        if(![messageQueue count])
            // No messages left, don't reschedule.
            return;
        
        [self schedule:@selector(popMessageQueue:) interval:1.5f];
    }
    
    NSString *msg = [[messageQueue lastObject] retain];
    [messageQueue removeLastObject];
    
    NSInvocation *callback = [[callbackQueue lastObject] retain];
    [callbackQueue removeLastObject];
    
    [self resetMessage:msg];
    [messageLabel runAction:[Sequence actions:
                             [MoveBy actionWithDuration:1 position:ccp(0, -([[Config get].fontSize intValue] * 2))],
                             [FadeTo actionWithDuration:2 opacity:0x00],
                             nil]];
    
    if(callback != (id)[NSNull null])
        [callback invoke];
    
    [callback release];
    [msg release];
}


-(void) resetMessage:(NSString *)msg {
    
    if(!messageLabel || [messageLabel numberOfRunningActions]) {
        // Detach existing label & create a new message label for the next message.
        if(messageLabel) {
            [messageLabel stopAllActions];
            [messageLabel runAction:[Sequence actions:
                                     [MoveTo actionWithDuration:1
                                                       position:ccp(-[messageLabel contentSize].width / 2, [messageLabel position].y)],
                                     [FadeOut actionWithDuration:1],
                                     [Remove action],
                                     nil]];
            [messageLabel release];
        }
        
        messageLabel = [[Label alloc] initWithString:msg
                                            fontName:[Config get].fixedFontName
                                            fontSize:[[Config get].fontSize intValue]];
        [self addChild: messageLabel z:1];
    }
    else
        [messageLabel setString:msg];
    
    CGSize winSize = [[Director sharedDirector] winSize];
    [messageLabel setPosition:ccp([messageLabel contentSize].width / 2 + [[Config get].fontSize intValue],
                                  winSize.height + [[Config get].fontSize intValue])];
    [messageLabel setOpacity:0xff];
}


-(void) dealloc {
    
    [rotateAction release];
    rotateAction = nil;
    
    [messageQueue release];
    messageQueue = nil;
    
    [callbackQueue release];
    callbackQueue = nil;

    [messageLabel release];
    messageLabel = nil;
    
    [super dealloc];
}


@end
