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
//  PearlLogger.m
//  Pearl
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

const char *PearlLogLevelStr(PearlLogLevel level) {

    switch (level) {
        case PearlLogLevelTrace:
            return "TRC";
        case PearlLogLevelDebug:
            return "DBG";
        case PearlLogLevelInfo:
            return "INF";
        case PearlLogLevelWarn:
            return "WRN";
        case PearlLogLevelError:
            return "ERR";
        case PearlLogLevelFatal:
            return "FTL";
    }

    Throw( @"Formatting a message with a log level that is not understood." );
}

id returnArg(id arg) {

    return arg;
}

@implementation PearlLogMessage

@synthesize message, occurrence, level;

+ (instancetype)messageInFile:(NSString *)fileName atLine:(long)lineNumber fromFunction:(NSString *)function
                    withLevel:(PearlLogLevel)aLevel text:(NSString *)aMessage {

    return [[self alloc] initInFile:fileName atLine:lineNumber fromFunction:function withLevel:aLevel text:aMessage];
}

- (id)initInFile:(NSString *)fileName atLine:(long)lineNumber fromFunction:(NSString *)function
       withLevel:(PearlLogLevel)aLevel text:(NSString *)aMessage {

    if (!(self = [super init]))
        return nil;

    self.fileName = fileName;
    self.lineNumber = lineNumber;
    self.function = function;
    self.level = aLevel;
    self.message = aMessage;
    self.occurrence = [NSDate date];

    return self;
}

- (NSDateFormatter *)occurrenceFormatter {

    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"DDD'-'HH':'mm':'ss"];
    }

    return dateFormatter;
}

- (NSString *)description {

    return [NSString stringWithFormat:@"%@ %@", [self occurrenceDescription], [self messageDescription]];
}

- (NSString *)occurrenceDescription {

    return [[self occurrenceFormatter] stringFromDate:self.occurrence];
}

- (NSString *)sourceDescription {

    return [NSString stringWithFormat:@"%s:%ld", self.fileName.UTF8String, self.lineNumber];
}

- (NSString *)messageDescription {

    return [NSString stringWithFormat:@"%30s:%-3ld %-3s | %@", //
                                      self.fileName.UTF8String, self.lineNumber, PearlLogLevelStr( self.level ), self.message];
}

@end

@interface PearlLogger()

@property(nonatomic, readwrite, retain) NSMutableArray *messages;
@property(nonatomic, readwrite, retain) NSMutableArray *listeners;

@end

@implementation PearlLogger

@synthesize messages = _messages, listeners = _listeners, printLevel = _printLevel;

- (id)init {

    if (!(self = [super init]))
        return nil;

    self.messages = [NSMutableArray arrayWithCapacity:20];
    self.listeners = [NSMutableArray arrayWithCapacity:1];
#if DEBUG
    self.printLevel = PearlLogLevelDebug;
    self.historyLevel = PearlLogLevelDebug;
    self.minimumLevel = PearlLogLevelTrace;
#else
    self.printLevel = PearlLogLevelInfo;
    self.historyLevel = PearlLogLevelWarn;
    self.minimumLevel = PearlLogLevelDebug;
#endif

    return self;
}

+ (instancetype)get {

    static PearlLogger *instance = nil;
    if (!instance)
        instance = [self new];

    return instance;
}

- (PearlLogLevel)minimumLevel {
    return MIN( MIN( _minimumLevel, _printLevel ), _historyLevel );
}

- (NSArray *)messagesWithLevel:(PearlLogLevel)level {

    @synchronized (self.messages) {
        NSMutableArray *messages = [self.messages mutableCopy];
        [messages filterUsingPredicate:[NSPredicate predicateWithBlock:
                ^BOOL(PearlLogMessage *message, NSDictionary *bindings) {
                    return message.level >= level;
                }]];

        return messages;
    };
}

- (NSString *)formatMessagesWithLevel:(PearlLogLevel)level {

    NSMutableString *formattedLog = [NSMutableString new];
    for (PearlLogMessage *message in [self messagesWithLevel:level]) {
        [formattedLog appendString:[message description]];
        [formattedLog appendString:@"\n"];
    }

    return formattedLog;
}

- (void)printAllWithLevel:(PearlLogLevel)level {

    @synchronized (self.messages) {
        for (PearlLogMessage *message in self.messages)
            if (message.level >= level)
                fprintf( stderr, "%s\n", [[message description] cStringUsingEncoding:NSUTF8StringEncoding] );
    }
}

- (void)registerListener:(BOOL ( ^ )(PearlLogMessage *message))listener {

    @synchronized (self.listeners) {
        [self.listeners addObject:listener];
    }
}

- (PearlLogger *)inFile:(NSString *)fileName atLine:(long)lineNumber fromFunction:(NSString *)function withLevel:(PearlLogLevel)level text:(NSString *)text {

    if (level < [PearlLogger get].minimumLevel)
        return self;

    NSMutableDictionary *threadLocals = [[NSThread currentThread] threadDictionary];
    if (!threadLocals || [[threadLocals allKeys] containsObject:@"PearlDisableLog"])
        return self;

    PearlLogMessage *message = [PearlLogMessage messageInFile:fileName atLine:lineNumber fromFunction:function withLevel:level text:text];
    @synchronized (self.listeners) {
        @try {
            threadLocals[@"PearlDisableLog"] = @YES;
            for (BOOL (^listener)(PearlLogMessage *) in self.listeners)
                if (!listener( message ))
                    return self;
        }
        @finally {
            [threadLocals removeObjectForKey:@"PearlDisableLog"];
        }
    }

    if (level >= self.printLevel)
        @synchronized (self) {
            fprintf( stderr, "%s\n", [[message description] cStringUsingEncoding:NSUTF8StringEncoding] );
        }
    if (message.level >= self.historyLevel)
        @synchronized (self.messages) {
            [self.messages addObject:message];
        }

    return self;
}

- (PearlLogger *)inFile:(NSString *)fileName atLine:(long)lineNumber fromFunction:(NSString *)function withLevel:(PearlLogLevel)level format:(NSString *)format args:(va_list)argList {

    if (level < [PearlLogger get].minimumLevel)
        return self;

    NSString *message;
    @try {
        message = [[NSString alloc] initWithFormat:format arguments:argList];
    }
    @catch (id exception) {
        @try {
            message = strf( @"Error formatting message: %@, error: %@", format, exception );
        }
        @catch (id exception) {
            @try {
                message = strf( @"Error formatting message: %@", format );
            }
            @catch (id exception) {
                message = @"Error formatting message";
            }
        }
    }

    return [self inFile:fileName atLine:lineNumber fromFunction:function withLevel:level text:message];
}

- (PearlLogger *)inFile:(const char *)fileName atLine:(long)lineNumber fromFunction:(const char *)function
                    trc:(NSString *)format, ... {

    va_list argList;
    va_start( argList, format );

    @try {
        return [self inFile:@(fileName) atLine:lineNumber fromFunction:@(function)
                  withLevel:PearlLogLevelTrace format:format args:argList];
    }
    @finally {
        va_end( argList );
    }
}

- (PearlLogger *)inFile:(const char *)fileName atLine:(long)lineNumber fromFunction:(const char *)function
                    dbg:(NSString *)format, ... {

    va_list argList;
    va_start( argList, format );

    @try {
        return [self inFile:@(fileName) atLine:lineNumber fromFunction:@(function)
                  withLevel:PearlLogLevelDebug format:format args:argList];
    }
    @finally {
        va_end( argList );
    }
}

- (PearlLogger *)inFile:(const char *)fileName atLine:(long)lineNumber fromFunction:(const char *)function
                    inf:(NSString *)format, ... {

    va_list argList;
    va_start( argList, format );

    @try {
        return [self inFile:@(fileName) atLine:lineNumber fromFunction:@(function)
                  withLevel:PearlLogLevelInfo format:format args:argList];
    }
    @finally {
        va_end( argList );
    }
}

- (PearlLogger *)inFile:(const char *)fileName atLine:(long)lineNumber fromFunction:(const char *)function
                    wrn:(NSString *)format, ... {

    va_list argList;
    va_start( argList, format );

    @try {
        return [self inFile:@(fileName) atLine:lineNumber fromFunction:@(function)
                  withLevel:PearlLogLevelWarn format:format args:argList];
    }
    @finally {
        va_end( argList );
    }
}

- (PearlLogger *)inFile:(const char *)fileName atLine:(long)lineNumber fromFunction:(const char *)function
                    err:(NSString *)format, ... {

    va_list argList;
    va_start( argList, format );

    @try {
        return [self inFile:@(fileName) atLine:lineNumber fromFunction:@(function)
                  withLevel:PearlLogLevelError format:format args:argList];
    }
    @finally {
        va_end( argList );
    }
}

- (PearlLogger *)inFile:(const char *)fileName atLine:(long)lineNumber fromFunction:(const char *)function
                    ftl:(NSString *)format, ... {

    va_list argList;
    va_start( argList, format );

    @try {
        return [self inFile:@(fileName) atLine:lineNumber fromFunction:@(function)
                  withLevel:PearlLogLevelFatal format:format args:argList];
    }
    @finally {
        va_end( argList );
    }
}

@end
