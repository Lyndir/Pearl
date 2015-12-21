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

#import <Foundation/Foundation.h>

#if DEBUG
#define prof_new(format, ...)       PearlProfiler * prof_new_var((format), ##__VA_ARGS__)
#define prof_new_var(format, ...)   __profiler = [PearlProfiler profilerInFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                                     forTask:(format), ##__VA_ARGS__]
#define prof_rewind(format, ...)    [__profiler rewindInFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                         job:(format), ##__VA_ARGS__]
#define prof_finish(format, ...)    [__profiler finishInFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                         job:(format), ##__VA_ARGS__]
#define prof_disable_if(condition)  if (condition) { [__profiler cancel]; }
#else
#define prof_new(format, ...)       while (0) {}
#define prof_new_var(format, ...)   while (0) {}
#define prof_rewind(format, ...)    while (0) {}
#define prof_finish(format, ...)    while (0) {}
#define prof_disable_if(condition)  while (0) {}
#endif

@interface PearlProfiler : NSObject

@property(nonatomic, copy, readonly) NSString *taskName;

/**
 * Create a profiler for a certain task.  The task name will be included in every job completion message logged.  Implicitly start a job.
 */
+ (instancetype)profilerInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function forTask:(NSString *)taskName, ... NS_FORMAT_FUNCTION( 4, 5 );

@property(nonatomic) CFTimeInterval threshold;
@property(nonatomic, copy) NSString *fileName;
@property(nonatomic) NSInteger lineNumber;
@property(nonatomic, copy) NSString *function;
/**
 * Start the timer for a job.
 */
- (void)startJobInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function;

/**
 * Restart the timer, logging a debug message which includes the completed job's elapsed time and the message.
 */
- (void)rewindInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function job:(NSString *)format, ... NS_FORMAT_FUNCTION( 4, 5 );

/**
 * Stop the timer, logging a debug message which includes the completed job's elapsed time and the message.
 */
- (void)finishInFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function job:(NSString *)format, ... NS_FORMAT_FUNCTION( 4, 5 );

/**
 * Stop the profiler's job.
 */
- (void)finish;

/**
 * Cancel the profiler, making it ignore any other operations.
 */
- (void)cancel;

@end
