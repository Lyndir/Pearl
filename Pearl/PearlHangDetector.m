//
// Created by Maarten Billemont on 2017-06-04.
// Copyright (c) 2017 Lyndir. All rights reserved.
//

#import "PearlHangDetector.h"

@interface PearlHangDetector()

@property(nonatomic, strong) NSDate *latestPing;
@property(nonatomic, copy) VoidBlock pingBlock, pongBlock;
@property(nonatomic, assign) dispatch_queue_t pingQueue, pongQueue;
@property(nonatomic) NSTimeInterval pingInterval, pongInterval, hangTimeout;
@property(nonatomic, copy) void (^hangAction)(NSTimeInterval);
@property(nonatomic, assign) BOOL running;

@end

@implementation PearlHangDetector

- (instancetype)init {

    return [self initWithHangAction:^(NSTimeInterval hangTime) {
        err( @"Timeout waiting for main thread after %fs.", hangTime );
    }];
}

- (instancetype)initWithHangAction:(void ( ^ )(NSTimeInterval hangTime))hangAction {

    return [self initWithPingQueue:dispatch_get_main_queue() hangAction:hangAction];
}

- (instancetype)initWithPingQueue:(dispatch_queue_t)pingQueue hangAction:(void ( ^ )(NSTimeInterval hangTime))hangAction {

    return [self initWithPingQueue:pingQueue interval:0.2
                         pongQueue:dispatch_get_global_queue( QOS_CLASS_BACKGROUND, 0 ) interval:1
                        hangAction:hangAction timeout:3];
}

- (instancetype)initWithPingQueue:(dispatch_queue_t)pingQueue interval:(NSTimeInterval)pingInterval
                        pongQueue:(dispatch_queue_t)pongQueue interval:(NSTimeInterval)pongInterval
                       hangAction:(void ( ^ )(NSTimeInterval hangTime))hangAction timeout:(NSTimeInterval)hangTimeout {

    if (!(self = [super init]))
        return nil;

    self.pingInterval = pingInterval;
    self.pingQueue = pingQueue;

    self.pongInterval = pongInterval;
    self.pongQueue = pongQueue;

    self.hangAction = hangAction;
    self.hangTimeout = hangTimeout;

    return self;
}

- (BOOL)start {

    if (self.running)
        return NO;

    if (self.pingBlock)
        dispatch_cancel( self.pingBlock );
    if (self.pongBlock)
        dispatch_cancel( self.pongBlock );

    self.running = YES;
    self.latestPing = [NSDate date];

    Weakify( self );
    dispatch_async( self.pingQueue, self.pingBlock = dispatch_block_create( 0, ^{
        Strongify( self );
        if (!self.running)
            return;

        self.latestPing = [NSDate date];

        if (self.running)
            PearlQueueAfter( self.pingInterval, self.pingQueue, self.pingBlock );
    } ) );
    dispatch_async( self.pongQueue, self.pongBlock = dispatch_block_create( 0, ^{
        Strongify( self );
        if (!self.running)
            return;

        NSTimeInterval hangTime = -[self.latestPing timeIntervalSinceNow];
        trc( @"hangTime=%f", hangTime );

        if (hangTime > self.hangTimeout)
            self.hangAction( hangTime );

        if (self.running)
            PearlQueueAfter( self.pongInterval, self.pongQueue, self.pongBlock );
    } ) );

    return YES;
}

- (BOOL)stop {

    if (!self.running)
        return NO;

    self.running = NO;

    if (self.pingBlock)
        dispatch_cancel( self.pingBlock );
    if (self.pongBlock)
        dispatch_cancel( self.pongBlock );

    return YES;
}

@end
