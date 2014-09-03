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

#define prof_new(format, ...)     PearlProfiler *__profiler = [PearlProfiler profilerInFile:basename((char *)__FILE__) \
                                                                                     atLine:__LINE__ forTask:(format), ##__VA_ARGS__]
#define prof_rewind(format, ...)  [__profiler rewindInFile:basename((char *)__FILE__) atLine:__LINE__ job:(format), ##__VA_ARGS__]
#define prof_finish(format, ...)  [__profiler finishInFile:basename((char *)__FILE__) atLine:__LINE__ job:(format), ##__VA_ARGS__]

@interface PearlProfiler : NSObject

@property(nonatomic, copy, readonly) NSString *taskName;

/**
 * Create a profiler for a certain task.  The task name will be included in every job completion message logged.  Implicitly start a job.
 */
+ (instancetype)profilerInFile:(char *)fileName atLine:(NSInteger)lineNumber forTask:(NSString *)taskName, ... NS_FORMAT_FUNCTION( 3, 4 );

@property(nonatomic) CFTimeInterval threshold;

/**
 * Start the timer for a job.
 */
- (void)startJobInFile:(char *)fileName atLine:(NSInteger)lineNumber;

/**
 * Restart the timer, logging a debug message which includes the completed job's elapsed time and the message.
 */
- (void)rewindInFile:(char *)fileName atLine:(NSInteger)lineNumber job:(NSString *)format, ... NS_FORMAT_FUNCTION( 3, 4 );

/**
 * Stop the timer, logging a debug message which includes the completed job's elapsed time and the message.
 */
- (void)finishInFile:(char *)fileName atLine:(NSInteger)lineNumber job:(NSString *)format, ... NS_FORMAT_FUNCTION( 3, 4 );

/**
 * Stop the profiler's job.
 */
- (void)finishInFile:(char *)fileName atLine:(NSInteger)lineNumber;

@end
