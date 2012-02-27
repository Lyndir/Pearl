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
//  PearlCryptUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <CommonCrypto/CommonHMAC.h>

#import "PearlCryptUtils.h"
#import "PearlLogger.h"


@implementation NSString (PearlCryptUtils)

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithSymmetricKey:symmetricKey usePadding:usePadding];
}

@end

@implementation NSData (PearlCryptUtils)

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    CCOptions options = kCCOptionECBMode;
    if (usePadding)
        options |= kCCOptionPKCS7Padding;
    
    return [self doCipher:kCCEncrypt withSymmetricKey:symmetricKey options:&options];
}

- (NSData *)decryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    CCOptions options = kCCOptionECBMode;
    if (usePadding)
        options |= kCCOptionPKCS7Padding;
    
    return [self doCipher:kCCDecrypt withSymmetricKey:symmetricKey options:&options];
}

- (NSData *)doCipher:(CCOperation)encryptOrDecrypt withSymmetricKey:(NSData *)symmetricKey options:(CCOptions *)options {
    
    if (symmetricKey.length < kCipherKeySize) {
        err(@"Key is too small for the cipher size (%d < %d)", symmetricKey.length, kCipherKeySize);
        return nil;
    }
    
    // Result buffer. (FIXME)
    void *buffer = calloc(1000, sizeof(uint8_t));
    size_t movedBytes;
    
    // Encrypt / Decrypt
    @try {
        CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt, kCipherAlgorithm, *options, 
                                           symmetricKey.bytes, symmetricKey.length,
                                           nil, self.bytes, self.length,
                                           buffer, sizeof(uint8_t) * 1000, &movedBytes);
        if (ccStatus != kCCSuccess) {
            err(@"Problem during cryption; ccStatus == %d.", ccStatus);
            return nil;
        }
        
        return [NSData dataWithBytes:buffer length:movedBytes];
    }
    @finally {
        free(buffer);
    }
}

- (NSData *)signWithAssymetricKeyFromTag:(NSString *)tag {
    
    switch ([self length]) {
        case 16:
            return [self signWithAssymetricKeyFromTag:tag usePadding:kSecPaddingPKCS1MD5];
        case 20:
            return [self signWithAssymetricKeyFromTag:tag usePadding:kSecPaddingPKCS1SHA1];
        default:
            return [self signWithAssymetricKeyFromTag:tag usePadding:kSecPaddingPKCS1];
    }
}

- (NSData *)signWithAssymetricKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding {
    
    NSDictionary *queryAttr     = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecClassKey,                (id)kSecClass,
                                   [[NSString stringWithFormat:@"%@-priv", tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   (id)kCFBooleanTrue,              (id)kSecReturnRef,
                                   nil];
    
    SecKeyRef privateKey = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)queryAttr, (CFTypeRef *) &privateKey);
    if (status != errSecSuccess || privateKey == nil) {
        err(@"Problem during key lookup; status == %d.", status);
        return nil;
    }
    
    
    // Malloc a buffer to hold signature.
    size_t signedHashBytesSize  = SecKeyGetBlockSize(privateKey);
    uint8_t *signedHashBytes    = calloc( signedHashBytesSize, sizeof(uint8_t) );
    
    // Sign the SHA1 hash.
    status = SecKeyRawSign(privateKey, padding,
                           self.bytes, self.length,
                           signedHashBytes, &signedHashBytesSize);
    CFRelease(privateKey);
    if (status != errSecSuccess) {
        err(@"Problem during data signing; status == %d.", status);
        return nil;
    }
    
    // Build up signed SHA1 blob.
    NSData *signedData = [NSData dataWithBytes:signedHashBytes length:signedHashBytesSize];
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedData;
}

@end

@implementation PearlCryptUtils

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha {
    
    // RFC4226, 5.1: Factor must be 8 bytes.
    factor = [factor subdataWithRange:NSMakeRange (0, 8)];
    
    // Result buffer.
    char *hmac = malloc(CC_SHA1_DIGEST_LENGTH);
    
    // Calculate the HMAC-SHA-1 of the moving factor with the key.
    CCHmac(kCCHmacAlgSHA1, key.bytes, key.length, factor.bytes, factor.length, hmac);
    
    // Truncate the result: Extract a 4-byte dynamic binary code from a 160-bit (20-byte) HMAC-SHA-1 result.
    int offset = hmac[CC_SHA1_DIGEST_LENGTH - 1] & 0xf;
    int otp = (hmac[offset + 0] & 0x7f) << 24 | //
    (hmac[offset + 1] & 0xff) << 16 | //
    (hmac[offset + 2] & 0xff) << 8 | //
    (hmac[offset + 3] & 0xff) << 0;
    
    // Extract otpLength digits out of the OTP data.
    return [NSString stringWithFormat:[NSString stringWithFormat:@"%%0%dd", otpLength], otp % (int) powf(10, otpLength)];
}

// Credits to Berin Lautenbach's "Importing an iPhone RSA public key into a Java app" -- http://blog.wingsofhermes.org/?p=42
// Helper function for ASN.1 encoding
static size_t derEncodeLength(unsigned char* buf, size_t length) {
    
    // encode length in ASN.1 DER format
    if (length < 128) {
        buf[0] = (char)length;
        return 1;
    }
    
    size_t i = (length / 256) + 1;
    buf[0] = (char)(i + 0x80);
    for (size_t j = 0 ; j < i; ++j) {
        buf[i - j] = length & 0xFF;
        length = length >> 8;
    }
    
    return i + 1;
}

+ (NSData *)derEncodeRSAKey:(NSData *)key {
    
    static const unsigned char _encodedRSAEncryptionOID[15] = {
        /* Sequence of length 0xd made up of OID followed by NULL */
        0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00
        
    };
    
    NSMutableData *encKey = [NSMutableData data];
    unsigned char builder[15];
    int bitstringEncLength;
    
    // When we get to the bitstring - how will we encode it?
    if  (key.length + 1 < 128)
        bitstringEncLength = 1;
    else
        bitstringEncLength = ((key.length + 1) / 256 ) + 2;
    
    // Overall we have a sequence of a certain length
    builder[0] = 0x30;    // ASN.1 encoding representing a SEQUENCE
                          // Build up overall size made up of -
                          // size of OID + size of bitstring encoding + size of actual key
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength + key.length;
    size_t j = derEncodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j +1];
    
    // First part of the sequence is the OID
    [encKey appendBytes:_encodedRSAEncryptionOID length:sizeof(_encodedRSAEncryptionOID)];
    
    // Now add the bitstring
    builder[0] = 0x03;
    j = derEncodeLength(&builder[1], key.length + 1);
    builder[j+1] = 0x00;
    [encKey appendBytes:builder length:j + 2];
    
    // Now the actual key
    [encKey appendData:key];
    
    return encKey;
}

@end
