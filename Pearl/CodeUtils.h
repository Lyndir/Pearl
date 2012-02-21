//
//  CodeUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    PearlDigestNone,
    PearlDigestMD4,
    PearlDigestMD5,
    PearlDigestSHA1,
    PearlDigestSHA224,
    PearlDigestSHA256,
    PearlDigestSHA384,
    PearlDigestSHA512,
    PearlDigestCount,
} PearlDigest;

PearlDigest PearlDigestFromNSString(NSString *digest);

@interface NSString (CodeUtils)

/** Generate a hash for the string. */
- (NSData *)hashWith:(PearlDigest)digest;

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

@interface NSData (CodeUtils)

/**
 * Concatenate the given data objects by putting the given delimitor inbetween them.
 */
+ (NSData *)dataByConcatenatingWithDelimitor:(char)delimitor datas:(NSData *)datas, ... NS_REQUIRES_NIL_TERMINATION;

/** Generate a hash for the bytes. */
- (NSData *)hashWith:(PearlDigest)digest;
/** Append the given delimitor and the given salt to the bytes. */
- (NSData *)saltWith:(NSData *)salt delimitor:(char)delimitor;

/** Create a string object by formatting the bytes as hexadecimal. */
- (NSString *)encodeHex;
/** Create a string object by formatting the bytes as base64. */
- (NSString *)encodeBase64;

/** Generate a data set whose bytes are the XOR operation between the bytes of this data object and those of the given otherData. */
- (NSData *)xorWith:(NSData *)otherData;

@end

@interface CodeUtils : NSObject

+ (NSString *)randomUUID;

@end
