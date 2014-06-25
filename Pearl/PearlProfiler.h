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

@interface PearlProfiler : NSObject

@property(nonatomic, copy, readonly) NSString *taskName;

/**
 * Create a profiler for a certain task.  The task name will be included in every job completion message logged.  Implicitly start a job.
 */
+ (instancetype)profilerForTask:(NSString *)taskName;

/**
 * Start the timer for a job.
 */
- (void)startJob;

/**
 * Stop the timer for a job, logging a debug message which includes the job's elapsed time and the message.
 */
- (void)finishJob:(NSString *)format, ... NS_FORMAT_FUNCTION( 1, 2 );

@end
