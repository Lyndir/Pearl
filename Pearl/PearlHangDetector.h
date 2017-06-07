//
// Created by Maarten Billemont on 2017-06-04.
// Copyright (c) 2017 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PearlHangDetector : NSObject

@property(nonatomic, assign, readonly) BOOL running;

- (instancetype)init;
- (instancetype)initWithHangAction:(void ( ^ )(NSTimeInterval hangTime))hangAction;
- (instancetype)initWithPingQueue:(dispatch_queue_t)pingQueue hangAction:(void ( ^ )(NSTimeInterval hangTime))hangAction;
- (instancetype)initWithPingQueue:(dispatch_queue_t)pingQueue interval:(NSTimeInterval)pingInterval
                        pongQueue:(dispatch_queue_t)pongQueue interval:(NSTimeInterval)pongInterval
                       hangAction:(void ( ^ )(NSTimeInterval hangTime))hangAction timeout:(NSTimeInterval)hangTimeout;

- (BOOL)start;
- (BOOL)stop;

@end
