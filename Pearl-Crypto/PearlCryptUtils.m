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
//  PearlCryptUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <CommonCrypto/CommonHMAC.h>

#import "PearlCryptUtils.h"

NSString *NSStringFromCCCryptorStatus(CCCryptorStatus status) {

    switch (status) {
        case kCCSuccess:
            return [NSString stringWithFormat:@"Operation completed normally (kCCSuccess: %d).", status];
        case kCCParamError:
            return [NSString stringWithFormat:@"Illegal parameter value (kCCParamError: %d).", status];
        case kCCBufferTooSmall:
            return [NSString stringWithFormat:@"Insufficent buffer provided for specified operation (kCCBufferTooSmall: %d).", status];
        case kCCMemoryFailure:
            return [NSString stringWithFormat:@"Memory allocation failure (kCCMemoryFailure: %d).", status];
        case kCCAlignmentError:
            return [NSString stringWithFormat:@"Input size was not aligned properly (kCCAlignmentError: %d).", status];
        case kCCDecodeError:
            return [NSString stringWithFormat:@"Input data did not decode or decrypt properly (kCCDecodeError: %d).", status];
        case kCCUnimplemented:
            return [NSString stringWithFormat:@"Function not implemented for the current algorithm (kCCUnimplemented: %d).", status];
    }

    wrn(@"Common Crypto status code not known: %d", status);
    return [NSString stringWithFormat:@"Unknown status (%d).", status];
}

NSString *NSStringFromErrSec(OSStatus status) {

    switch (status) {
        case errSecSuccess:
            return [NSString stringWithFormat:@"No error (errSecSuccess: %ld).", (long)status];
        case errSecUnimplemented:
            return [NSString stringWithFormat:@"Function or operation not implemented (errSecUnimplemented: %ld).", (long)status];
        case errSecParam:
            return [NSString stringWithFormat:@"One or more parameters passed to a function where not valid (errSecParam: %ld).", (long)status];
        case errSecAllocate:
            return [NSString stringWithFormat:@"Failed to allocate memory (errSecAllocate: %ld).", (long)status];
        case errSecNotAvailable:
            return [NSString stringWithFormat:@"No keychain is available. You may need to restart your computer (errSecNotAvailable: %ld).", (long)status];
        case errSecDuplicateItem:
            return [NSString stringWithFormat:@"The specified item already exists in the keychain (errSecDuplicateItem: %ld).", (long)status];
        case errSecItemNotFound:
            return [NSString stringWithFormat:@"The specified item could not be found in the keychain (errSecItemNotFound: %ld).", (long)status];
        case errSecInteractionNotAllowed:
            return [NSString stringWithFormat:@"User interaction is not allowed (errSecInteractionNotAllowed: %ld).", (long)status];
        case errSecDecode:
            return [NSString stringWithFormat:@"Unable to decode the provided data (errSecDecode: %ld).", (long)status];
        case errSecAuthFailed:
            return [NSString stringWithFormat:@"The user name or passphrase you entered is not correct (errSecAuthFailed: %ld).", (long)status];
        default:
            wrn(@"Security Error status code not known: %ld", (long)status);
            return PearlString(@"Unknown status (%ld).", (long)status);
    }
}

@implementation NSString (PearlCryptUtils)

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey padding:(BOOL)padding {

    return [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithSymmetricKey:symmetricKey padding:padding];
}

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options {

    return [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithSymmetricKey:symmetricKey options:options];
}

@end

@implementation NSData (PearlCryptUtils)

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey padding:(BOOL)padding {

    CCOptions options = 0;
    if (padding)
        options |= kCCOptionPKCS7Padding;

    return [self encryptWithSymmetricKey:symmetricKey options:options];
}

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options {

    return [self doCipher:kCCEncrypt withSymmetricKey:symmetricKey options:options];
}

- (NSData *)decryptWithSymmetricKey:(NSData *)symmetricKey padding:(BOOL)padding {

    CCOptions options = 0;
    if (padding)
        options |= kCCOptionPKCS7Padding;

    return [self decryptWithSymmetricKey:symmetricKey options:options];
}

- (NSData *)decryptWithSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options {

    return [self doCipher:kCCDecrypt withSymmetricKey:symmetricKey options:options];
}

- (NSData *)doCipher:(CCOperation)encryptOrDecrypt withSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options {

    if (symmetricKey.length != PearlCryptKeySize) {
        err(@"Key size (%ld) doesn't match cipher size (%d).", (long)symmetricKey.length, PearlCryptKeySize);
        return nil;
    }

    // Encrypt / Decrypt
    void *buffer = malloc(self.length + PearlCryptBlockSize);
    @try {
        size_t          movedBytes;
        CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt, PearlCryptAlgorithm, options,
                                           symmetricKey.bytes, symmetricKey.length,
         nil, self.bytes, self.length,
                                           buffer, self.length + PearlCryptBlockSize, &movedBytes);
        if (ccStatus != kCCSuccess) {
            err(@"Problem during %@: %@",
            encryptOrDecrypt == kCCEncrypt? @"encryption": @"decryption", NSStringFromCCCryptorStatus(ccStatus));
            return nil;
        }

        return [NSData dataWithBytes:buffer length:movedBytes];
    }
    @finally {
        free(buffer);
    }
}

@end

@implementation PearlCryptUtils

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha {

    // RFC4226, 5.1: Factor must be 8 bytes.
    factor = [factor subdataWithRange:NSMakeRange(0, 8)];

    // Result buffer.
    char *hmac = malloc(CC_SHA1_DIGEST_LENGTH);

    // Calculate the HMAC-SHA-1 of the moving factor with the key.
    CCHmac(kCCHmacAlgSHA1, key.bytes, key.length, factor.bytes, factor.length, hmac);

    // Truncate the result: Extract a 4-byte dynamic binary code from a 160-bit (20-byte) HMAC-SHA-1 result.
    int offset = hmac[CC_SHA1_DIGEST_LENGTH - 1] & 0xf;
    int otp    = (hmac[offset + 0] & 0x7f) << 24 | //
     (hmac[offset + 1] & 0xff) << 16 | //
     (hmac[offset + 2] & 0xff) << 8 | //
     (hmac[offset + 3] & 0xff) << 0;
    free(hmac);

    // Extract otpLength digits out of the OTP data.
    return PearlString(PearlString(@"%%0%lud", (long)otpLength), otp % (int)powf(10, otpLength));
}

// Credits to Berin Lautenbach's "Importing an iPhone RSA public key into a Java app" -- http://blog.wingsofhermes.org/?p=42
// Helper function for ASN.1 encoding
static size_t DEREncodeLength(unsigned char *buf, size_t length) {

    // encode length in ASN.1 DER format
    if (length < 128) {
        buf[0] = (unsigned char)length;
        return 1;
    }

    size_t i = (length / 256) + 1;
    buf[0] = (unsigned char)(i + 0x80);
    for (size_t j = 0; j < i; ++j) {
        buf[i - j] = (unsigned char)(length & 0xFF);
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
    unsigned long bitstringEncLength;

    // When we get to the bitstring - how will we encode it?
    if (key.length + 1 < 128)
        bitstringEncLength = 1;
    else
        bitstringEncLength = ((key.length + 1) / 256) + 2;

    // Overall we have a sequence of a certain length
    builder[0] = 0x30;    // ASN.1 encoding representing a SEQUENCE
    // Build up overall size made up of -
    // size of OID + size of bitstring encoding + size of actual key
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength + key.length;
    size_t j = DEREncodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j + 1];

    // First part of the sequence is the OID
    [encKey appendBytes:_encodedRSAEncryptionOID length:sizeof(_encodedRSAEncryptionOID)];

    // Now add the bitstring
    builder[0] = 0x03;
    j = DEREncodeLength(&builder[1], key.length + 1);
    builder[j + 1] = 0x00;
    [encKey appendBytes:builder length:j + 2];

    // Now the actual key
    [encKey appendData:key];

    return encKey;
}

@end
