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
//  PearlCCUILayer.m
//  Pearl
//
//  Created by Maarten Billemont on 08/03/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCUILayer.h"
#import "PearlCCRemove.h"
#import "PearlConfig.h"
#import "PearlCCDebug.h"

#define AccelerometerFilteringFactor            0.4f
#define AccelerometerFrequency     50 //Hz


@interface PearlCCUILayer ()

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


@implementation PearlCCUILayer

@synthesize messageLabel = _messageLabel;
@synthesize messageQueue = _messageQueue, callbackQueue = _callbackQueue;
@synthesize rotateAction = _rotateAction;
@synthesize accelX = _accelX, accelY = _accelY, accelZ = _accelZ;


-(id) init {
#ifdef DEBUG
	if (!(self = [super initWithColor:ccc4(0xff, 0x77, 0x88, 0x99)]))
		return self;
#else
	if (!(self = [super initWithColor:ccc4(0x00, 0x00, 0x00, 0xff)]))
		return self;
#endif
    
    // Build internal structures.
    self.messageQueue = [NSMutableArray arrayWithCapacity:3];
    self.callbackQueue = [NSMutableArray arrayWithCapacity:3];
    
    //[self schedule:@selector(debug:) interval:1];

    return self;
}

- (void)onEnter {
    
    [self setContentSize:[CCDirector sharedDirector].winSize];

    [super onEnter];
}

- (void)debug:(ccTime)delta {
    
    id sceneCandidate = self;
    while (![sceneCandidate isKindOfClass:[CCScene class]]) {
        sceneCandidate = [sceneCandidate parent];
        
        if (!sceneCandidate)
            // No scene in hierarchy.
            return;
    }
    
    [PearlCCDebug printStateForScene:sceneCandidate];
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
                             [CCMoveBy actionWithDuration:1 position:ccp(0, -([[PearlConfig get].fontSize intValue] * 2))],
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
                                     [PearlCCRemove action],
                                     nil]];
        }
        
        self.messageLabel = [CCLabelTTF labelWithString:msg
                                          fontName:[PearlConfig get].fixedFontName
                                          fontSize:[[PearlConfig get].fontSize intValue]];
        [self addChild: self.messageLabel z:1];
    }
    else
        [self.messageLabel setString:msg];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [self.messageLabel setPosition:ccp([self.messageLabel contentSize].width / 2 + [[PearlConfig get].fontSize intValue],
                                  winSize.height + [[PearlConfig get].fontSize intValue])];
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
