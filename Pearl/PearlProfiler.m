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

static CFTimeInterval profilerThreshold = 1.0 / 60;
static NSUInteger profilerJobs = 0;

@interface PearlProfiler()

@property(nonatomic, copy, readwrite) NSString *taskName;
@end

@implementation PearlProfiler {
  CFTimeInterval _startTime;
  CFTimeInterval _totalTime;
}

+ (void)setDefaultThreshold:(CFTimeInterval)threshold {

  profilerThreshold = threshold;
}

+ (instancetype)profilerInFile:(char *)fileName atLine:(NSInteger)lineNumber forTask:(NSString *)taskName, ... {

    if (MIN([PearlLogger get].printLevel, [PearlLogger get].historyLevel) > PearlLogLevelDebug)
        return nil;

    PearlProfiler *profiler = [self new];
    profiler.threshold = profilerThreshold;

    va_list args;
    va_start( args, taskName );
    profiler.taskName = [[NSString alloc] initWithFormat:taskName arguments:args];
    va_end( args );

    [profiler startJobInFile:fileName atLine:lineNumber];

    return profiler;
}

- (void)startJobInFile:(char *)fileName atLine:(NSInteger)lineNumber {

    NSMutableString *spaces = [NSMutableString stringWithCapacity:profilerJobs * 2];
    for (NSUInteger j = 0; j < profilerJobs; ++j)
        [spaces appendString:@"  "];

    if (!_startTime)
        [[PearlLogger get] inFile:fileName atLine:lineNumber dbg:@"[         ]  %@> [%@] begin", spaces, self.taskName];

    _startTime = CACurrentMediaTime();
    ++profilerJobs;
}

- (void)logJob:(NSString *)format args:(va_list)args inFile:(char *)fileName atLine:(NSInteger)lineNumber {

    CFTimeInterval endTime = CACurrentMediaTime();
    if (!_startTime) {
        wrn( @"Profiler not started: %@, when finished job: %@", self.taskName, format );
        [self startJobInFile:fileName atLine:lineNumber];
        return;
    }
    --profilerJobs;

    CFTimeInterval jobTime = endTime - _startTime;
    _totalTime += jobTime;

    if (jobTime >= self.threshold) {
        NSString *job = [[NSString alloc] initWithFormat:format arguments:args];

        NSMutableString *spaces = [NSMutableString stringWithCapacity:profilerJobs * 2];
        for (NSUInteger j = 0; j < profilerJobs; ++j)
            [spaces appendString:@"  "];

        [[PearlLogger get] inFile:fileName atLine:lineNumber dbg:@"[+%0.6f]  %@- [%@] %@", jobTime, spaces, self.taskName, job];
    }
}

- (void)logTotalInFile:(char *)fileName atLine:(NSInteger)lineNumber {

    if (_totalTime >= self.threshold) {
        NSMutableString *spaces = [NSMutableString stringWithCapacity:profilerJobs * 2];
        for (NSUInteger j = 0; j < profilerJobs; ++j)
            [spaces appendString:@"  "];

        [[PearlLogger get] inFile:fileName atLine:lineNumber dbg:@"[+%0.6f]  %@< [%@] total", _totalTime, spaces, self.taskName];
    }
}

-(void)rewindInFile:(char *)fileName atLine:(NSInteger)lineNumber job:(NSString *)format, ... {

    va_list args;
    va_start( args, format );
    [self logJob:format args:args inFile:fileName atLine:lineNumber];
    va_end( args );

    [self startJobInFile:fileName atLine:lineNumber];
}

- (void)finishInFile:(char *)fileName atLine:(NSInteger)lineNumber job:(NSString *)format, ... {

    va_list args;
    va_start( args, format );
    [self logJob:format args:args inFile:fileName atLine:lineNumber];
    va_end( args );

    _startTime = 0;
    [self logTotalInFile:fileName atLine:lineNumber];
}

- (void)finishInFile:(char *)fileName atLine:(NSInteger)lineNumber {

    if (_startTime) {
        _startTime = 0;
        --profilerJobs;
    }

    [self logTotalInFile:fileName atLine:lineNumber];
}

- (void)dealloc {

    if (_startTime) {
        wrn( @"Unfinished profiler: %@", self.taskName );
        [self finishInFile:basename( (char *)__FILE__ ) atLine:__LINE__];
    }
}

@end
