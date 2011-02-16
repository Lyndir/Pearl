//
//  CryptUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "CryptUtils.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#define kCipherAlgorithm    kCCAlgorithmAES128
#define kCipherKeySize      kCCKeySizeAES128
#define kCipherBlockSize    8


@implementation InvalidKeyException

+ (void)raise {
    
    [self raise:[self description] format:@"Could not decrypt the ciphertext with the given key."];
}

@end

@implementation NSString (CryptUtils)

+ (NSString *)hexStringWithData:(NSData *)data {
    
    NSMutableString *hashString = [NSMutableString stringWithCapacity:data.length * 2];
    for (NSUInteger i = 0; i < data.length; ++i)
        [hashString appendFormat:@"%02hhx", ((char *)data.bytes)[i]];
    
    return hashString;
}

- (NSData *)md5Data {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5];
}

- (NSString *)md5 {

    return [NSString hexStringWithData:[self md5Data]];
}

- (NSData *)sha1Data {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1];
}

- (NSString *)sha1 {
    
    return [NSString hexStringWithData:[self sha1Data]];
}

- (NSData *)encryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithKey:symmetricKey usePadding:usePadding];
}

@end

@implementation NSData (CryptUtils)

- (NSData *)md5 {
    
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(self.bytes, self.length, result);
    
    return [NSData dataWithBytes:result length:sizeof(result)];
}

- (NSData *)sha1 {
    
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(self.bytes, self.length, result);
    
    return [NSData dataWithBytes:result length:sizeof(result)];
}

- (NSData *)xor:(NSData *)otherData {
    
    if (self.length != otherData.length)
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Input data must have the same length for an XOR operation to work." userInfo:nil];
    
    NSData *xorData = [self copy];
    for (NSUInteger b = 0; b < xorData.length; ++b)
        ((char *)xorData.bytes)[b] ^= ((char *)otherData.bytes)[b];
    
    return xorData;
}

- (NSData *)encryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    CCOptions options = kCCOptionECBMode;
    if (usePadding)
        options |= kCCOptionPKCS7Padding;
    
    return [self doCipher:kCCEncrypt withKey:symmetricKey options:&options];
}

- (NSData *)decryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    CCOptions options = kCCOptionECBMode;
    if (usePadding)
        options |= kCCOptionPKCS7Padding;
    
    return [self doCipher:kCCDecrypt withKey:symmetricKey options:&options];
}

- (NSData *)doCipher:(CCOperation)encryptOrDecrypt withKey:(NSData *)symmetricKey options:(CCOptions *)options {
    
    if (symmetricKey.length < kCipherKeySize)
        [NSException raise:NSInvalidArgumentException
                    format:@"Key is too small for the cipher size (%d < %d)", symmetricKey.length, kCipherKeySize];
    
    // Result buffer. (FIXME)
    void *buffer = calloc(1000, sizeof(uint8_t));
    size_t movedBytes;
    
    // Encrypt / Decrypt
    CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt, kCipherAlgorithm, *options, 
                                       symmetricKey.bytes, symmetricKey.length,
                                       nil, self.bytes, self.length,
                                       buffer, sizeof(uint8_t) * 1000, &movedBytes);
    if (ccStatus == kCCDecodeError)
        [InvalidKeyException raise];
    if (ccStatus != kCCSuccess)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Problem during cryption; ccStatus == %d.", ccStatus];
    
    NSData *result = [NSData dataWithBytes:buffer length:movedBytes];
    free(buffer);
    
    return result;
}

@end
