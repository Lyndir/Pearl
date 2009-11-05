//
//  CryptUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//


/**
 * An exception that indicates decryption was attempted with an invalid key.
 */
@interface InvalidKeyException : NSException

+ (void)raise;

@end


/**
 * Generic convenience utilities.
 *
 * This class provides a collection of utilities for performing generic tasks.  It is stateless and only contains class methods.
 */
@interface CryptUtils : NSObject {

}

/** Generate a hexadecimal encoded MD5 hash for the given string. */
+ (NSString *)md5:(NSString *)string;

/** Generate an NSData object with the MD5 hash for the given string. */
+ (NSData *)md5Data:(NSString *)string;

/** Generate a hexadecimal encoded SHA1 hash for the given string. */
+ (NSString *)sha1:(NSString *)string;

/** Generate an NSData object with the SHA1 hash for the given string. */
+ (NSData *)sha1Data:(NSString *)string;

/** Generate a data set whose bytes are the XOR operation between the bytes of the two input datasets. */
+ (NSData *)xor:(NSData *)data1 :(NSData *)data2;

/** Encrypt a string of plain text using the MD5 hash of the given encryption key string. */
+ (NSData *)encryptString:(NSString *)plainText
               withString:(NSString *)key;

/** Encrypt some plain text using a given key. */
+ (NSData *)encryptData:(NSData *)plainText
                withKey:(NSData *)key;

/** Decrypt some encrypted text using a given key. */
+ (NSData *)decryptData:(NSData *)encryptedData
                withKey:(NSData *)key;

@end
