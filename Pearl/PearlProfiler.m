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
//  PearlProfiler.h
//  PearlProfiler
//
//  Created by lhunath on 2014-06-24.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PearlProfiler.h"

@interface PearlProfiler()

@property(nonatomic, copy, readwrite) NSString *taskName;
@end

@implementation PearlProfiler { CFTimeInterval _startTime; }

+ (instancetype)profilerForTask:(NSString *)taskName {

    PearlProfiler *profiler = [self new];
    profiler.taskName = taskName;
    
    return profiler;
}

- (id)init {

    if (!(self = [super init]))
        return nil;

    [self startJob];

    return self;
}

- (void)startJob {

    _startTime = CACurrentMediaTime();
}

- (void)finishJob:(NSString *)format, ... {

    CFTimeInterval endTime = CACurrentMediaTime();

    va_list args;
    va_start( args, format );
    NSString *job = [[NSString alloc] initWithFormat:format arguments:args];
    va_end( args );

    dbg( @"[%@: +%f] %@", self.taskName, endTime - _startTime, job );

    [self startJob];
}

@end
