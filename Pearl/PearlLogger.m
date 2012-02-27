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
//  PearlLogger.m
//  Pearl
//
//  Created by Maarten Billemont on 21/08/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlLogger.h"
@implementation PearlLogMessage

@synthesize message, occurance, level;

static NSDateFormatter *PearlLogDateFormatter = nil;

+ (void)initialize {
    
    [super initialize];
    
    if (!PearlLogDateFormatter) {
        PearlLogDateFormatter = [NSDateFormatter new];
        [PearlLogDateFormatter setDateStyle:NSDateFormatterNoStyle];
        [PearlLogDateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
}


+ (PearlLogMessage *)messageWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(PearlLogLevel)aLevel {
    
    return [[[self alloc] initWithMessage:aMessage at:anOccurance withLevel:aLevel] autorelease];
}


- (id)initWithMessage:(NSString *)aMessage at:(NSDate *)anOccurance withLevel:(PearlLogLevel)aLevel {
    
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
        case PearlLogLevelTrace:
            return @"[TRACE]  ";
            break;
        case PearlLogLevelDebug:
            return  @"[DEBUG]  ";
            break;
        case PearlLogLevelInfo:
            return  @"[INFO]   ";
            break;
        case PearlLogLevelWarn:
            return  @"[WARNING]";
            break;
        case PearlLogLevelError:
            return  @"[ERROR]  ";
            break;
        case PearlLogLevelFatal:
            return  @"[FATAL]  ";
            break;
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Formatting a message with a log level that is not understood."];
    }
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@ %@\n",
            [PearlLogDateFormatter stringFromDate:self.occurance], [self messageDescription]];
}

- (NSString *)messageDescription {
    
    return [NSString stringWithFormat:@"%@ %@\n",
            [self levelDescription], self.message];
}

- (void)dealloc {
    
    self.message = nil;
    self.occurance = nil;
    
    [super dealloc];
}

@end


@interface PearlLogger ()

@property (readwrite, retain) NSMutableArray           *messages;
@property (readwrite, retain) NSMutableArray           *listeners;

@end


@implementation PearlLogger

@synthesize messages = _messages, listeners = _listeners, autoprintLevel = _autoprintLevel;

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    self.messages = [NSMutableArray arrayWithCapacity:20];
    self.listeners = [NSMutableArray array];
    self.autoprintLevel = PearlLogLevelInfo;
    
    return self;
}


+ (PearlLogger *)get {
    
    static PearlLogger *instance = nil;
    if (!instance)
        instance = [PearlLogger new];
    
    return instance;
}


- (NSString *)formatMessages {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSMutableString *formattedLog = [NSMutableString new];
    for (PearlLogMessage *message in self.messages)
        [formattedLog appendString:[message description]];
    
    [dateFormatter release];
    
    return [formattedLog autorelease];
}


- (void)registerListener:(BOOL (^)(PearlLogMessage *message))listener {
    
    [self.listeners addObject:listener];
}


- (PearlLogger *)logWithLevel:(PearlLogLevel)aLevel andMessage:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    
    NSString *messageString = [[NSString alloc] initWithFormat:format arguments:argList];
    PearlLogMessage *message = [PearlLogMessage messageWithMessage:messageString at:nil withLevel:aLevel];
    [messageString release];
    
    va_end(argList);
    
    for (BOOL (^listener)(PearlLogMessage *message) in self.listeners)
        if (!listener(message))
            return self;
    
    if (aLevel >= self.autoprintLevel)
        NSLog(@"%@", [message messageDescription]);
    if (message.level > PearlLogLevelTrace)
        [self.messages addObject:message];
    
    return self;
}


- (void)printAllWithLevel:(PearlLogLevel)level {
    
    for (PearlLogMessage *message in self.messages)
        if (message.level >= level)
            NSLog(@"%@", message);
}


- (PearlLogger *)trc:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:PearlLogLevelTrace andMessage:[message autorelease]];
}


- (PearlLogger *)dbg:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:PearlLogLevelDebug andMessage:[message autorelease]];
}


- (PearlLogger *)inf:(NSString *)format, ... {

    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:PearlLogLevelInfo andMessage:[message autorelease]];
}


- (PearlLogger *)wrn:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:PearlLogLevelWarn andMessage:[message autorelease]];
}


- (PearlLogger *)err:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:PearlLogLevelError andMessage:[message autorelease]];
}


- (PearlLogger *)ftl:(NSString *)format, ... {
    
    va_list argList;
    va_start(argList, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);
    
    return [self logWithLevel:PearlLogLevelFatal andMessage:[message autorelease]];
}


- (void)dealloc {
    
    self.messages = nil;
    
    [super dealloc];
}

@end


NSString *errstr() {
    
    switch (errno) {
        case 1:
            return @"EPERM (1): Operation not permitted";
        case 2:
            return @"ENOENT (2): No such file or directory";
        case 3:
            return @"ESRCH (3): No such process";
        case 4:
            return @"EINTR (4): Interrupted system call";
        case 5:
            return @"EIO (5): Input/output error";
        case 6:
            return @"ENXIO (6): Device not configured";
        case 7:
            return @"E2BIG (7): Argument list too long";
        case 8:
            return @"ENOEXEC (8): Exec format error";
        case 9:
            return @"EBADF (9): Bad file descriptor";
        case 10:
            return @"ECHILD (10): No child processes";
        case 11:
            return @"EDEADLK (11): Resource deadlock avoided";
        case 12:
            return @"ENOMEM (12): Cannot allocate memory";
        case 13:
            return @"EACCES (13): Permission denied";
        case 14:
            return @"EFAULT (14): Bad address";
        case 15:
            return @"ENOTBLK (15): Block device required";
        case 16:
            return @"EBUSY (16): Device / Resource busy";
        case 17:
            return @"EEXIST (17): File exists";
        case 18:
            return @"EXDEV (18): Cross-device link";
        case 19:
            return @"ENODEV (19): Operation not supported by device";
        case 20:
            return @"ENOTDIR (20): Not a directory";
        case 21:
            return @"EISDIR (21): Is a directory";
        case 22:
            return @"EINVAL (22): Invalid argument";
        case 23:
            return @"ENFILE (23): Too many open files in system";
        case 24:
            return @"EMFILE (24): Too many open files";
        case 25:
            return @"ENOTTY (25): Inappropriate ioctl for device";
        case 26:
            return @"ETXTBSY (26): Text file busy";
        case 27:
            return @"EFBIG (27): File too large";
        case 28:
            return @"ENOSPC (28): No space left on device";
        case 29:
            return @"ESPIPE (29): Illegal seek";
        case 30:
            return @"EROFS (30): Read-only file system";
        case 31:
            return @"EMLINK (31): Too many links";
        case 32:
            return @"EPIPE (32): Broken pipe";
        case 33:
            return @"EDOM (33): Numerical argument out of domain";
        case 34:
            return @"ERANGE (34): Result too large";
        case 35:
            return @"EAGAIN (35): Resource temporarily unavailable";
        case 36:
            return @"EINPROGRESS (36): Operation now in progress";
        case 37:
            return @"EALREADY (37): Operation already in progress";
        case 38:
            return @"ENOTSOCK (38): Socket operation on non-socket";
        case 39:
            return @"EDESTADDRREQ (39): Destination address required";
        case 40:
            return @"EMSGSIZE (40): Message too long";
        case 41:
            return @"EPROTOTYPE (41): Protocol wrong type for socket";
        case 42:
            return @"ENOPROTOOPT (42): Protocol not available";
        case 43:
            return @"EPROTONOSUPPORT (43): Protocol not supported";
        case 44:
            return @"ESOCKTNOSUPPORT (44): Socket type not supported";
        case 45:
            return @"ENOTSUP (45): Operation not supported";
        case 46:
            return @"EPFNOSUPPORT (46): Protocol family not supported";
        case 47:
            return @"EAFNOSUPPORT (47): Address family not supported by protocol family";
        case 48:
            return @"EADDRINUSE (48): Address already in use";
        case 49:
            return @"EADDRNOTAVAIL (49): Can't assign requested address";
        case 50:
            return @"ENETDOWN (50): Network is down";
        case 51:
            return @"ENETUNREACH (51): Network is unreachable";
        case 52:
            return @"ENETRESET (52): Network dropped connection on reset";
        case 53:
            return @"ECONNABORTED (53): Software caused connection abort";
        case 54:
            return @"ECONNRESET (54): Connection reset by peer";
        case 55:
            return @"ENOBUFS (55): No buffer space available";
        case 56:
            return @"EISCONN (56): Socket is already connected";
        case 57:
            return @"ENOTCONN (57): Socket is not connected";
        case 58:
            return @"ESHUTDOWN (58): Can't send after socket shutdown";
        case 59:
            return @"ETOOMANYREFS (59): Too many references: can't splice";
        case 60:
            return @"ETIMEDOUT (60): Operation timed out";
        case 61:
            return @"ECONNREFUSED (61): Connection refused";
        case 62:
            return @"ELOOP (62): Too many levels of symbolic links";
        case 63:
            return @"ENAMETOOLONG (63): File name too long";
        case 64:
            return @"EHOSTDOWN (64): Host is down";
        case 65:
            return @"EHOSTUNREACH (65): No route to host";
        case 66:
            return @"ENOTEMPTY (66): Directory not empty";
        case 67:
            return @"EPROCLIM (67): Too many processes";
        case 68:
            return @"EUSERS (68): Too many users";
        case 69:
            return @"EDQUOT (69): Disc quota exceeded";
        case 70:
            return @"ESTALE (70): Stale NFS file handle";
        case 71:
            return @"EREMOTE (71): Too many levels of remote in path";
        case 72:
            return @"EBADRPC (72): RPC struct is bad";
        case 73:
            return @"ERPCMISMATCH (73): RPC version wrong";
        case 74:
            return @"EPROGUNAVAIL (74): RPC prog. not avail";
        case 75:
            return @"EPROGMISMATCH (75): Program version wrong";
        case 76:
            return @"EPROCUNAVAIL (76): Bad procedure for program";
        case 77:
            return @"ENOLCK (77): No locks available";
        case 78:
            return @"ENOSYS (78): Function not implemented";
        case 79:
            return @"EFTYPE (79): Inappropriate file type or format";
        case 80:
            return @"EAUTH (80): Authentication error";
        case 81:
            return @"ENEEDAUTH (81): Need authenticator";
        case 82:
            return @"EPWROFF (82): Device power is off";
        case 83:
            return @"EDEVERR (83): Device error, e.g. paper out";
        case 84:
            return @"EOVERFLOW (84): Value too large to be stored in data type";
        case 85:
            return @"EBADEXEC (85): Bad executable";
        case 86:
            return @"EBADARCH (86): Bad CPU type in executable";
        case 87:
            return @"ESHLIBVERS (87): Shared library version mismatch";
        case 88:
            return @"EBADMACHO (88): Malformed Macho file";
        case 89:
            return @"ECANCELED (89): Operation canceled";
        case 90:
            return @"EIDRM (90): Identifier removed";
        case 91:
            return @"ENOMSG (91): No message of desired type";
        case 92:
            return @"EILSEQ (92): Illegal byte sequence";
        case 93:
            return @"ENOATTR (93): Attribute not found";
        case 94:
            return @"EBADMSG (94): Bad message";
        case 95:
            return @"EMULTIHOP (95): Reserved";
        case 96:
            return @"ENODATA (96): No message available on STREAM";
        case 97:
            return @"ENOLINK (97): Reserved";
        case 98:
            return @"ENOSR (98): No STREAM resources";
        case 99:
            return @"ENOSTR (99): Not a STREAM";
        case 100:
            return @"EPROTO (100): Protocol error";
        case 101:
            return @"ETIME (101): STREAM ioctl timeout";
        case 102:
            return @"EOPNOTSUPP (102): Operation not supported on socket";
        case 103:
            return @"ENOPOLICY (103): No such policy registered";
        case 104:
            return @"ENOTRECOVERABLE (104): State not recoverable";
        case 105:
            return @"EOWNERDEAD (105): Previous owner died";
        default:
            return [NSString stringWithFormat:@"UNKNOWN (%d): Unknown error code", errno];
    }
}
