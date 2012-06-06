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
//  PearlCodeUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    PearlHashNone,
    PearlHashMD4,
    PearlHashMD5,
    PearlHashSHA1,
    PearlHashSHA224,
    PearlHashSHA256,
    PearlHashSHA384,
    PearlHashSHA512,
    PearlHashCount,
} PearlHash;

PearlHash PearlHashFromNSString(NSString *hash);
uint64_t PearlSecureRandom(void);

@interface NSString (PearlCodeUtils)

/** Generate a hash for the string. */
- (NSData *)hashWith:(PearlHash)hash;

/** Decode a hex-encoded string into bytes. */
- (NSData *)decodeHex;
/** Decode a base64-encoded string into bytes. */
- (NSData *)decodeBase64;

/** Encode the string for injection into parameters of a URL. */
- (NSString *)encodeURL;

- (NSString *)inject:(NSString *)injection interval:(NSUInteger)interval;
- (NSString *)wrapAt:(NSUInteger)lineLength;
- (NSString *)wrapForMIME;
- (NSString *)wrapForPEM;

@end

@interface NSData (PearlCodeUtils)

/**
 * Concatenate the given data objects.
 */
+ (NSData *)dataByConcatenatingDatas:(NSData *)datas, ...;

/**
 * Concatenate the given data objects by putting the given delimitor inbetween them.
 */
+ (NSData *)dataByConcatenatingWithDelimitor:(char)delimitor datas:(NSData *)datas, ... NS_REQUIRES_NIL_TERMINATION;

/** Generate a hash for the bytes. */
- (NSData *)hashWith:(PearlHash)hash;
/** Generate a message authentication code based on the given hash function, using the given secret key. */
- (NSData *)hmacWith:(PearlHash)hash key:(NSData *)key;
/** Append the given delimitor and the given salt to the bytes. */
- (NSData *)saltWith:(NSData *)salt delimitor:(char)delimitor;

/** Create a string object by formatting the bytes as hexadecimal. */
- (NSString *)encodeHex;
/** Create a string object by formatting the bytes as base64. */
- (NSString *)encodeBase64;

/** Generate a data set whose bytes are the XOR operation between the bytes of this data object and those of the given otherData. */
- (NSData *)xorWith:(NSData *)otherData;

@end

@interface PearlCodeUtils : NSObject

+ (NSString *)randomUUID;

@end
