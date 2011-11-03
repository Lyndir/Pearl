//
//  Logger.m
//  Pearl
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "Logger.h"

@implementation LogMessage

@synthesize message, occurance, level;

static NSDateFormatter *logDateFormatter = nil;

+ (void)initialize {

    [super initialize];
    
    if (!logDateFormatter) {
        logDateFormatter = [NSDateFormatter new];
        [logDateFormatter setDateStyle:NSDateFormatterNoStyle];
        [logDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
}


+ (LogMessage *)messageWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(LogLevel)aLevel {

    return [[[self alloc] initWithMessage:aMessage at:anOccurance withLevel:aLevel] autorelease];
}


- (id)initWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(LogLevel)aLevel {

    if (!(self = [super init]))
        return nil;
    
    self.message    = aMessage;
    self.occurance  = anOccurance;
    self.level      = aLevel;
    
    if (!self.occurance)
        self.occurance = [NSDate date];
    
    return self;
}

- (NSString *)levelDescription {
    
    switch (self.level) {
        case LogLevelTrace:
            return @"[TRACE]  ";
            break;
        case LogLevelDebug:
            return  @"[DEBUG]  ";
            break;
        case LogLevelInfo:
            return  @"[INFO]   ";
            break;
        case LogLevelWarn:
            return  @"[WARNING]";
            break;
        case LogLevelError:
            return  @"[ERROR]  ";
            break;
        case LogLevelFatal:
            return  @"[FATAL]  ";
            break;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Formatting a message with a log level that is not understood."];
    }
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@ %@ %@\n",
            [logDateFormatter stringFromDate:self.occurance], [self levelDescription], self.message];
}

- (void)dealloc {
    
    self.message = nil;
    self.occurance = nil;

    [super dealloc];
}

@end


@interface Logger ()

@property (readwrite, retain) NSMutableArray           *messages;
@property (readwrite, retain) NSMutableArray           *listeners;

@end


@implementation Logger

@synthesize messages = _messages, listeners = _listeners, autoprintLevel = _autoprintLevel;

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    self.messages = [NSMutableArray arrayWithCapacity:20];
    self.listeners = [NSMutableArray array];
    self.autoprintLevel = LogLevelInfo;
    
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
    for (LogMessage *message in self.messages)
        [formattedLog appendString:[message description]];
    
    [dateFormatter release];
    
    return [formattedLog autorelease];
}


- (void)registerListener:(BOOL (^)(LogMessage *message))listener {
    
    [self.listeners addObject:listener];
}


- (Logger *)logWithLevel:(LogLevel)aLevel andMessage:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    
    NSString *messageString = [[NSString alloc] initWithFormat:format arguments:argList];
    LogMessage *message = [LogMessage messageWithMessage:messageString at:nil withLevel:aLevel];
    [messageString release];
    
    va_end(argList);
    
    for (BOOL (^listener)(LogMessage *message) in self.listeners)
        if (!listener(message))
            return self;

    if (aLevel >= self.autoprintLevel)
        NSLog(@"%@", message);
    if (message.level > LogLevelTrace)
        [self.messages addObject:message];
    
    return self;
}


- (void)printAllWithLevel:(LogLevel)level {
    
    for (LogMessage *message in self.messages)
        if (message.level >= level)
            NSLog(@"%@", message);
}


- (Logger *)trc:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelTrace andMessage:[message autorelease]];
}


- (Logger *)dbg:(NSString *)format, ... {

    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
 
    return [self logWithLevel:LogLevelDebug andMessage:[message autorelease]];
}


- (Logger *)inf:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelInfo andMessage:[message autorelease]];
}


- (Logger *)wrn:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelWarn andMessage:[message autorelease]];
}


- (Logger *)err:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelError andMessage:[message autorelease]];
}


- (Logger *)ftl:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:LogLevelFatal andMessage:[message autorelease]];
}


- (void)dealloc {

    self.messages = nil;

    [super dealloc];
}

@end
