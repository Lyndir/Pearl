//
//  CryptUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "CryptUtils.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

#define kCipherAlgorithm    kCCAlgorithmAES128
#define kCipherKeySize      kCCKeySizeAES128
#define kCipherBlockSize    8


@implementation InvalidKeyException

+ (void)raise {
    
    [self raise:[self description] format:@"Could not decrypt the ciphertext with the given key."];
}

@end


@interface CryptUtils ()

+ (NSData *)encrypt:(NSData *)plainText key:(NSData *)aSymmetricKey
            options:(CCOptions *) options;

+ (NSData *)decrypt:(NSData *)plainText key:(NSData *)aSymmetricKey
            options:(CCOptions *) options;

+ (NSData *)doCipher:(NSData *)data key:(NSData *)aSymmetricKey
             context:(CCOperation)encryptOrDecrypt options:(CCOptions *) options;



@end


@implementation CryptUtils




+ (NSString *)md5:(NSString *)string {

    NSData *data = [CryptUtils md5Data:string];
    NSMutableString *md5String = [NSMutableString stringWithCapacity:data.length];
    
    for (NSUInteger i = 0; i < data.length; ++i)
        [md5String appendFormat:@"%02hhx", ((char *)data.bytes)[i]];
    
    return md5String;
}


+ (NSData *)md5Data:(NSString *)string {
    
    const char *cString = [string UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cString, strlen(cString), result);

    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}


+ (NSString *)sha1:(NSString *)string {
    
    NSData *data = [CryptUtils sha1Data:string];
    NSMutableString *sha1String = [NSMutableString stringWithCapacity:data.length];
    
    for (NSUInteger i = 0; i < data.length; ++i)
        [sha1String appendFormat:@"%02hhx", ((char *)data.bytes)[i]];
    
    return sha1String;
}


+ (NSData *)sha1Data:(NSString *)string {
    
    const char *cString = [string UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cString, strlen(cString), result);
    
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}


+ (NSData *)xor:(NSData *)data1 :(NSData *)data2 {
    
    if (data1.length != data2.length)
        [NSException raise:NSInvalidArgumentException format:@"Input data must have the same length for an XOR operation to work."];
    
    NSData *result = [NSData dataWithData:data1];
    for (NSUInteger b = 0; b < result.length; ++b)
        ((char *)result.bytes)[b] ^= ((char *)data2.bytes)[b];
    
    return result;
}


+ (NSData *)encryptString:(NSString *)plainText
               withString:(NSString *)key {
    
    CCOptions options = kCCOptionECBMode |kCCOptionPKCS7Padding;
    return [CryptUtils encrypt:[plainText dataUsingEncoding:NSUTF8StringEncoding]
                        key:[CryptUtils sha1Data:key]
                    options:& options];
}


+ (NSData *)encryptData:(NSData *)plainText
                withKey:(NSData *)key {
    
    CCOptions options = kCCOptionECBMode | kCCOptionPKCS7Padding;
    return [CryptUtils encrypt:plainText key:key
                    options:& options];
}


+ (NSData *)decryptData:(NSData *)encryptedData
                withKey:(NSData *)key {
    
    CCOptions options = kCCOptionECBMode |kCCOptionPKCS7Padding;
    return [CryptUtils decrypt:encryptedData key:key
                    options:& options];
}


+ (NSData *)encrypt:(NSData *)plainText key:(NSData *)aSymmetricKey
            options:(CCOptions *) options {

    return [CryptUtils doCipher:plainText key:aSymmetricKey
                     context:kCCEncrypt options: options];
}


+ (NSData *)decrypt:(NSData *)plainText key:(NSData *)aSymmetricKey
            options:(CCOptions *) options {
    
    return [CryptUtils doCipher:plainText key:aSymmetricKey
                     context:kCCDecrypt options: options];
}


+ (NSData *)doCipher:(NSData *)data key:(NSData *)aSymmetricKey
             context:(CCOperation)encryptOrDecrypt options:(CCOptions *)options {
    
    if (aSymmetricKey.length < kCipherKeySize)
        [NSException raise:NSInvalidArgumentException
                    format:@"Key is too small for the cipher size (%d < %d)", aSymmetricKey.length, kCipherKeySize];

    // Result buffer. (FIXME)
    void *buffer = calloc(1000, sizeof(uint8_t));
    size_t movedBytes;

    // Encrypt / Decrypt
    CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt, kCipherAlgorithm, *options,
                                       [aSymmetricKey subdataWithRange:NSMakeRange(0, kCipherKeySize)].bytes, kCipherKeySize,
                                       nil, data.bytes, data.length,
                                       buffer, sizeof(uint8_t) * 1000, &movedBytes);
    if (ccStatus == kCCDecodeError)
        [InvalidKeyException raise];
    if (ccStatus != kCCSuccess)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Problem during cryption; ccStatus == %d.", ccStatus];
    
    return [NSData dataWithBytes:buffer length:movedBytes];
}


@end
