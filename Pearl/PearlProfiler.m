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

#import "PearlProfiler.h"
#import <QuartzCore/QuartzCore.h>

static CFTimeInterval profilerThreshold = 1.0 / 600;
static NSUInteger profilerJobs = 0;

@interface PearlProfiler()

@property(nonatomic, copy, readwrite) NSString *taskName;
@end

@implementation PearlProfiler {
  CFTimeInterval _startTime;
  CFTimeInterval _totalTime;
  BOOL _cancelled;
}

+ (void)setDefaultThreshold:(CFTimeInterval)threshold {

  profilerThreshold = threshold;
}

+ (instancetype)profilerInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function forTask:(NSString *)taskName, ... {

    if (MIN([PearlLogger get].printLevel, [PearlLogger get].historyLevel) > PearlLogLevelDebug)
        return nil;

    PearlProfiler *profiler = [self new];
    profiler.threshold = profilerThreshold;
    profiler.fileName = [NSString stringWithUTF8String:fileName];
    profiler.lineNumber = lineNumber;
    profiler.function = [NSString stringWithUTF8String:function];

    va_list args;
    va_start( args, taskName );
    profiler.taskName = [[NSString alloc] initWithFormat:taskName arguments:args];
    va_end( args );

    [profiler startJobInFile:fileName atLine:lineNumber fromFunction:function];

    return profiler;
}

- (void)startJobInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function {

    if (_cancelled)
        return;

    NSMutableString *spaces = [NSMutableString stringWithCapacity:profilerJobs * 2];
    for (NSUInteger j = 0; j < profilerJobs; ++j)
        [spaces appendString:@"  "];

    if (_startTime == 0)
        [[PearlLogger get] inFile:fileName atLine:lineNumber fromFunction:function
                              dbg:@"[         ]  %@> [%@] begin", spaces, self.taskName];

    _startTime = CACurrentMediaTime();
    ++profilerJobs;
}

- (void)logJob:(NSString *)format args:(va_list)args inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function {

    if (_cancelled)
        return;

    CFTimeInterval endTime = CACurrentMediaTime();
    if (_startTime == 0) {
        [[PearlLogger get] inFile:[self.fileName UTF8String] atLine:self.lineNumber fromFunction:[self.function UTF8String]
                              wrn:@"Profiler not started: %@, when finished job: %@", self.taskName, format];
        [self startJobInFile:fileName atLine:lineNumber fromFunction:function];
        return;
    }
    --profilerJobs;

    CFTimeInterval jobTime = endTime - _startTime;
    _totalTime += jobTime;

    NSString *job = [[NSString alloc] initWithFormat:format arguments:args];

    NSMutableString *spaces = [NSMutableString stringWithCapacity:profilerJobs * 2];
    for (NSUInteger j = 0; j < profilerJobs; ++j)
        [spaces appendString:@"  "];

    if (jobTime >= self.threshold)
        [[PearlLogger get] inFile:fileName atLine:lineNumber fromFunction:function
                              dbg:@"[+%0.6f]  %@- [%@] %@", jobTime, spaces, self.taskName, job];
    else
        [[PearlLogger get] inFile:fileName atLine:lineNumber fromFunction:function
                              trc:@"[+%0.6f]  %@- [%@] %@", jobTime, spaces, self.taskName, job];
}

- (void)logTotal {

    if (_cancelled)
        return;

    if (_totalTime >= self.threshold) {
        NSMutableString *spaces = [NSMutableString stringWithCapacity:profilerJobs * 2];
        for (NSUInteger j = 0; j < profilerJobs; ++j)
            [spaces appendString:@"  "];

        [[PearlLogger get] inFile:[self.fileName UTF8String] atLine:self.lineNumber fromFunction:[self.function UTF8String]
                              dbg:@"[+%0.6f]  %@< [%@] total", _totalTime, spaces, self.taskName];
    }
}

-(void)rewindInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function job:(NSString *)format, ... {

    if (_cancelled)
        return;

    va_list args;
    va_start( args, format );
    [self logJob:format args:args inFile:fileName atLine:lineNumber fromFunction:function];
    va_end( args );

    [self startJobInFile:fileName atLine:lineNumber fromFunction:function];
}

- (void)finishInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function job:(NSString *)format, ... {

    if (_cancelled)
        return;

    va_list args;
    va_start( args, format );
    [self logJob:format args:args inFile:fileName atLine:lineNumber fromFunction:function];
    va_end( args );

    _startTime = 0;
    [self logTotal];
}

- (void)finish {

    if (_startTime != 0) {
        _startTime = 0;
        --profilerJobs;
    }

    [self logTotal];
}

- (void)cancel {

    if (_startTime != 0) {
        _startTime = 0;
        --profilerJobs;
    }

  _cancelled = YES;
}

- (void)dealloc {

    if (_startTime != 0) {
        [[PearlLogger get] inFile:[self.fileName UTF8String] atLine:self.lineNumber fromFunction:[self.function UTF8String]
                              wrn:@"Unfinished profiler: %@", self.taskName];
        [self finish];
    }
}

@end
