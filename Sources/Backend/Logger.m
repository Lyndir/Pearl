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
//  Logger.m
//  iLibs
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "Logger.h"


@interface LogMessage : NSObject
{
@private
    NSString                    *message;
    NSDate                      *occurance;
    LogLevel                    level;
}

@property (readonly) NSString   *message;
@property (readonly) NSDate     *occurance;
@property (readonly) LogLevel   level;

+ (LogMessage *)messageWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(LogLevel)aLevel;

- (id)initWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(LogLevel)aLevel;

@end

@implementation LogMessage

@synthesize message, occurance, level;

+ (LogMessage *)messageWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(LogLevel)aLevel {

    return [[[self alloc] initWithMessage:aMessage at:anOccurance withLevel:aLevel] autorelease];
}


- (id)initWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(LogLevel)aLevel {

    if (!(self = [super init]))
        return nil;
    
    message     = [aMessage copy];
    occurance   = [anOccurance copy];
    level       = aLevel;
    
    if (!occurance)
        occurance = [NSDate new];
    
    return self;
}

@end


@implementation Logger

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    messages = [[NSMutableArray alloc] initWithCapacity:20];
    
    return self;
}


+ (Logger *)get {
    
    static Logger *logger = nil;
    if (!logger)
        logger = [Logger new];
    
    return logger;
}


- (NSString *)formatMessages {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSMutableString *formattedLog = [NSMutableString new];
    for (LogMessage *message in messages) {
        NSString *occurance = [dateFormatter stringFromDate:message.occurance];
        
        NSString *level;
        switch (message.level) {
            case LogLevelDebug:
                level = @"DEBUG";
                break;
            case LogLevelInfo:
                level = @"INFO";
                break;
            case LogLevelWarn:
                level = @"WARNING";
                break;
            case LogLevelError:
                level = @"ERROR";
                break;
            default:
                [NSException raise:NSInternalInconsistencyException
                            format:@"Formatting a message with a log level that is not understood."];
        }
        
        [formattedLog appendFormat:@"%@ [%-7@] %@\n", occurance, level, message.message];
    }
    
    [dateFormatter release];
    
    return [formattedLog autorelease];
}


- (Logger *)logWithLevel:(LogLevel)aLevel andMessage:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);

    NSLog(@"%@", message);
    [messages addObject:[LogMessage messageWithMessage:message at:nil withLevel:aLevel]];
    
    return self;
}


- (Logger *)dbg:(NSString *)format, ... {

    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
 
    return [self logWithLevel:LogLevelDebug andMessage:message];
}


- (Logger *)inf:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelInfo andMessage:message];
}


- (Logger *)wrn:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelWarn andMessage:message];
}


- (Logger *)err:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelError andMessage:message];
}


@end
