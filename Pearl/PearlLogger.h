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
//  PearlLogger.h
//  Pearl
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libgen.h>

#define trc(format, ...)    [[PearlLogger get] trc:@"%25s:%-3d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define dbg(format, ...)    [[PearlLogger get] dbg:@"%25s:%-3d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define inf(format, ...)    [[PearlLogger get] inf:@"%25s:%-3d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define wrn(format, ...)    [[PearlLogger get] wrn:@"%25s:%-3d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define err(format, ...)    [[PearlLogger get] err:@"%25s:%-3d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]
#define ftl(format, ...)    [[PearlLogger get] ftl:@"%25s:%-3d | " format, basename(__FILE__), __LINE__ , ##__VA_ARGS__]

NSString *errstr(void);

/** Levels that determine the importance of logging events. */
typedef enum LogLevel {
    /** Trace internal operations. */
    PearlLogLevelTrace,
    /** Inform the developer of certain events and information. */
    PearlLogLevelDebug,
    /** General notice to the user and developer that something took place. */
    PearlLogLevelInfo,
    /** Notice that something unexpected happened but was dealt with as best as possible. */
    PearlLogLevelWarn,
    /** Notice that something went wrong that should be fixed. */
    PearlLogLevelError,
    /** Notice that something went wrong from which could not be recovered, causing the operation to abort. */
    PearlLogLevelFatal
} PearlLogLevel;

@interface PearlLogMessage : NSObject
{
@private
    NSString                            *message;
    NSDate                              *occurance;
    PearlLogLevel                            level;
}

@property (readwrite, copy) NSString    *message;
@property (readwrite, copy) NSDate      *occurance;
@property (readwrite) PearlLogLevel          level;

+ (PearlLogMessage *)messageWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(PearlLogLevel)aLevel;

- (id)initWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(PearlLogLevel)aLevel;
- (NSString *)levelDescription;
- (NSString *)messageDescription;

@end

/**
 * The Logger class provides a very simple general purpose Logging framework.
 *
 * All logged events are emitted to the system console and stored for later retrieval.
 * -formatMessages can be used to retrieve all logged events and format them nicely for the user.
 */
@interface PearlLogger : NSObject {

@private
    NSMutableArray                      *_messages;
    NSMutableArray                      *_listeners;
    PearlLogLevel                            _autoprintLevel;
}

@property (nonatomic, assign) PearlLogLevel  autoprintLevel;

/** Obtain the shared Logger instance. */
+ (PearlLogger *)get;

/** Obtain the logged events in a formatted string fit for display. */
- (NSString *)formatMessages;

/** Register a listener invoked for each message that gets logged.
 * 
 * @param listener A block that takes a message and returns YES if the message may be logged and passed to other listeners, or NO if its handling should be stopped and the message should not be logged. */
- (void)registerListener:(BOOL (^)(PearlLogMessage *message))listener;

/** Log a new event on a specified level.
 *
 * @andMessage  First argument is a printf(3)-style format string.
 *              Subsequent nil-terminated arguments are arguments to the format string.
 */
- (PearlLogger *)logWithLevel:(PearlLogLevel)aLevel andMessage:(NSString *)format, ...;
/** Print all log messages of the given level or above to the console. */
- (void)printAllWithLevel:(PearlLogLevel)level;
/** Log a new TRACE-level event. */
- (PearlLogger *)trc:(NSString *)format, ...;
/** Log a new DEBUG-level event. */
- (PearlLogger *)dbg:(NSString *)format, ...;
/** Log a new INFO-level event. */
- (PearlLogger *)inf:(NSString *)format, ...;
/** Log a new WARNING-level event. */
- (PearlLogger *)wrn:(NSString *)format, ...;
/** Log a new ERROR-level event. */
- (PearlLogger *)err:(NSString *)format, ...;
/** Log a new FATAL-level event. */
- (PearlLogger *)ftl:(NSString *)format, ...;

@end
