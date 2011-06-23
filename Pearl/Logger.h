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
//  Logger.h
//  Pearl
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libgen.h>

#define dbg(format, ...)    [[Logger get] dbg:@"%20s:%-5d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define inf(format, ...)    [[Logger get] inf:@"%20s:%-5d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define wrn(format, ...)    [[Logger get] wrn:@"%20s:%-5d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define err(format, ...)    [[Logger get] err:@"%20s:%-5d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]

/** Levels that determine the importance of logging events. */
typedef enum LogLevel {
    /** Inform the developer of certain events and information. */
    LogLevelDebug,
    /** General notice to the user and developer that something took place. */
    LogLevelInfo,
    /** Notice that something unexpected happened but was dealt with as best as possible. */
    LogLevelWarn,
    /** Notice that something went wrong that should be fixed. */
    LogLevelError
} LogLevel;

/**
 * The Logger class provides a very simple general purpose Logging framework.
 *
 * All logged events are emitted to the system console and stored for later retrieval.
 * -formatMessages can be used to retrieve all logged events and format them nicely for the user.
 */
@interface Logger : NSObject {

@private
    NSMutableArray                      *_messages;
    LogLevel                            _autoprintLevel;
}

@property (nonatomic, assign) LogLevel  autoprintLevel;

/** Obtain the shared Logger instance. */
+ (Logger *)get;

/** Obtain the logged events in a formatted string fit for display. */
- (NSString *)formatMessages;

/** Log a new event on a specified level.
 *
 * @andMessage  First argument is a printf(3)-style format string.
 *              Subsequent nil-terminated arguments are arguments to the format string.
 */
- (Logger *)logWithLevel:(LogLevel)aLevel andMessage:(NSString *)format, ...;
/** Print all log messages of the given level or above to the console. */
- (void)printAllWithLevel:(LogLevel)level;
/** Log a new DEBUG-level event. */
- (Logger *)dbg:(NSString *)format, ...;
/** Log a new INFO-level event. */
- (Logger *)inf:(NSString *)format, ...;
/** Log a new WARNING-level event. */
- (Logger *)wrn:(NSString *)format, ...;
/** Log a new ERROR-level event. */
- (Logger *)err:(NSString *)format, ...;

@end
