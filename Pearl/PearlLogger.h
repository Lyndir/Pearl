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
//  PearlLogger.h
//  Pearl
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libgen.h>

#define trc(format, ...)    ([[PearlLogger get] inFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                  trc:(format), ##__VA_ARGS__])
#define dbg(format, ...)    ([[PearlLogger get] inFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                  dbg:(format), ##__VA_ARGS__])
#define inf(format, ...)    ([[PearlLogger get] inFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                  inf:(format), ##__VA_ARGS__])
#define wrn(format, ...)    ([[PearlLogger get] inFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                  wrn:(format), ##__VA_ARGS__])
#define err(format, ...)    ([[PearlLogger get] inFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                  err:(format), ##__VA_ARGS__])
#define ftl(format, ...)    ([[PearlLogger get] inFile:basename((char *)__FILE__) atLine:__LINE__ fromFunction:__FUNCTION__ \
                                                  ftl:(format), ##__VA_ARGS__])
#define dbg_return(__ret, ...)   dbg_return_tr(__ret, )
#define dbg_return_tr(__ret, __to_id, ...) \
                            do { \
                                typeof(__ret) __R = __ret; \
                                NSArray *__args = @[ __VA_ARGS__ ]; \
                                if ([__args count]) \
                                    dbg(@"%s %@ => %@", sel_getName(_cmd), __args, __to_id(__R)); \
                                else \
                                    dbg(@"%s => %@", sel_getName(_cmd), __to_id(__R)); \
                                return __R; \
                            } while(0)

__BEGIN_DECLS
/** Levels that determine the importance of logging events. */
typedef NS_ENUM(NSUInteger, PearlLogLevel) {
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
};

extern const char *PearlLogLevelStr(PearlLogLevel level);
extern id returnArg(id arg);
__END_DECLS

@interface PearlLogMessage : NSObject

@property(nonatomic, readwrite, strong) NSString *fileName;
@property(nonatomic, readwrite) NSInteger lineNumber;
@property(nonatomic, readwrite, strong) NSString *function;
@property(nonatomic, readwrite, copy) NSString *message;
@property(nonatomic, readwrite, strong) NSDate *occurrence;
@property(nonatomic, readwrite) PearlLogLevel level;

+ (instancetype)messageInFile:(NSString *)fileName atLine:(NSInteger)lineNumber fromFunction:(NSString *)function
                    withLevel:(PearlLogLevel)aLevel text:(NSString *)aMessage;

- (id)initInFile:(NSString *)fileName atLine:(NSInteger)lineNumber fromFunction:(NSString *)function
       withLevel:(PearlLogLevel)aLevel text:(NSString *)aMessage;

- (NSString *)occurrenceDescription;
- (NSString *)messageDescription;
@end

/**
 * The Logger class provides a very simple general purpose Logging framework.
 *
 * All logged events are emitted to the system console and stored for later retrieval.
 * -formatMessages can be used to retrieve all logged events and format them nicely for the user.
 */
@interface PearlLogger : NSObject

/** Starting from which level messages are written to the console when they are logged. */
@property(nonatomic, assign) PearlLogLevel printLevel;

/** Starting from which level messages are recorded in memory when they are logged. */
@property(nonatomic, assign) PearlLogLevel historyLevel;

/** Obtain the shared Logger instance. */
+ (instancetype)get;

/** Obtain the logged events in a formatted string fit for display. Requires history to be enabled. */
- (NSArray *)messagesWithLevel:(PearlLogLevel)level;

/** Obtain the logged events in a formatted string fit for display. Requires history to be enabled. */
- (NSString *)formatMessagesWithLevel:(PearlLogLevel)level;

/** Print all log messages of the given level or above to the console. Requires history to be enabled. */
- (void)printAllWithLevel:(PearlLogLevel)level;

/** Register a listener invoked for each message that gets logged.
 *
 * @param listener A block that takes a message and returns YES if the message may be logged and passed to other listeners, or NO if its handling should be stopped and the message should not be logged. */
- (void)registerListener:(BOOL (^)(PearlLogMessage *message))listener;

/** Log a new event on a specified level. */
- (PearlLogger *)inFile:(NSString *)fileName atLine:(NSInteger)lineNumber fromFunction:(NSString *)function
              withLevel:(PearlLogLevel)level text:(NSString *)text;
- (PearlLogger *)inFile:(NSString *)fileName atLine:(NSInteger)lineNumber fromFunction:(NSString *)function
              withLevel:(PearlLogLevel)level format:(NSString *)format args:(va_list)argList;

/** Log a new TRACE-level event. */
- (PearlLogger *)inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function
                    trc:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);
/** Log a new DEBUG-level event. */
- (PearlLogger *)inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function
                    dbg:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);
/** Log a new INFO-level event. */
- (PearlLogger *)inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function
                    inf:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);
/** Log a new WARNING-level event. */
- (PearlLogger *)inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function
                    wrn:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);
/** Log a new ERROR-level event. */
- (PearlLogger *)inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function
                    err:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);
/** Log a new FATAL-level event. */
- (PearlLogger *)inFile:(const char *)fileName atLine:(NSInteger)lineNumber fromFunction:(const char *)function
                    ftl:(NSString *)format, ... NS_FORMAT_FUNCTION(4, 5);

@end
