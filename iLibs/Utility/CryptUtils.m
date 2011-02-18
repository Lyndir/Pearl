//
//  CryptUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "CryptUtils.h"
#import "Logger.h"

#define kCipherAlgorithm    kCCAlgorithmAES128
#define kCipherKeySize      kCCKeySizeAES128
#define kCipherBlockSize    8


@implementation InvalidKeyException

+ (void)raise {
    
    [self raise:[self description] format:@"Could not decrypt the ciphertext with the given key."];
}

@end

@implementation NSString (CryptUtils)

- (NSData *)md5Data {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5];
}

- (NSString *)md5 {
    
    return [[self md5Data] hex];
}

- (NSData *)sha1Data {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1];
}

- (NSString *)sha1 {
    
    return [[self sha1Data] hex];
}

- (NSData *)encryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithKey:symmetricKey usePadding:usePadding];
}

@end

@implementation NSData (CryptUtils)

- (NSString *)hex {
    
    NSMutableString *hex = [NSMutableString stringWithCapacity:self.length * 2];
    for (NSUInteger i = 0; i < self.length; ++i)
        [hex appendFormat:@"%02hhx", ((char *)self.bytes)[i]];
    
    return hex;
}

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
    @try {
        CCCryptorStatus ccStatus = CCCrypt(encryptOrDecrypt, kCipherAlgorithm, *options, 
                                           symmetricKey.bytes, symmetricKey.length,
                                           nil, self.bytes, self.length,
                                           buffer, sizeof(uint8_t) * 1000, &movedBytes);
        if (ccStatus == kCCDecodeError)
            return nil;
        if (ccStatus != kCCSuccess)
            [NSException raise:NSInternalInconsistencyException
                        format:@"Problem during cryption; ccStatus == %d.", ccStatus];
        
        return [NSData dataWithBytes:buffer length:movedBytes];
    }
    @finally {
        free(buffer);
    }
}

- (NSData *)signWithKeyFromTag:(NSString *)tag {
    
    NSDictionary *queryAttr     = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecClassKey,                (id)kSecClass,
                                   [[NSString stringWithFormat:@"%@-priv", tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   (id)kCFBooleanTrue,              (id)kSecReturnRef,
                                   nil];
    
    SecKeyRef privateKey = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)queryAttr, (CFTypeRef *) &privateKey);
    if (status != errSecSuccess || privateKey == nil)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Problem during key lookup; status == %d.", status];
    
    
    // Malloc a buffer to hold signature.
    size_t signedHashBytesSize  = SecKeyGetBlockSize(privateKey);
    uint8_t *signedHashBytes    = calloc( signedHashBytesSize, sizeof(uint8_t) );
    
    // Sign the SHA1 hash.
    dbg(@"signing data: %@, <%@>, len: %d",
        self, [[[NSString alloc] initWithBytes:self.bytes length:self.length encoding:NSUTF8StringEncoding] autorelease], self.length);
    status = SecKeyRawSign(privateKey, kSecPaddingPKCS1SHA1,
                           self.bytes, self.length,
                           signedHashBytes, &signedHashBytesSize);
    CFRelease(privateKey);
    if (status != errSecSuccess)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Problem during data signing; status == %d.", status];
    
    // Build up signed SHA1 blob.
    NSData *signedData = [NSData dataWithBytes:signedHashBytes length:signedHashBytesSize];
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedData;
}

@end

@implementation CryptUtils

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

+ (NSData *)generateKeyPairWithTag:(NSString *)tag {
    
    NSDictionary *privKeyAttr   = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString stringWithFormat:@"%@-priv",  tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   nil];
    NSDictionary *pubKeyAttr    = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString stringWithFormat:@"%@-pub",   tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   nil];
    NSDictionary *keyPairAttr   = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   [NSNumber numberWithInt:1024],   (id)kSecAttrKeySizeInBits,
                                   (id)kCFBooleanTrue,              (id)kSecAttrIsPermanent,
                                   privKeyAttr,                     (id)kSecPrivateKeyAttrs,
                                   pubKeyAttr,                      (id)kSecPublicKeyAttrs,
                                   nil];
    
    OSStatus status = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, nil, nil);
    if (status != errSecSuccess)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Problem during key generation; status == %d.", status];
    
    NSData *publicKeyData = nil;
    NSDictionary *queryAttr     = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecClassKey,                (id)kSecClass,
                                   [[NSString stringWithFormat:@"%@-pub",  tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   (id)kCFBooleanTrue,              (id)kSecReturnData,
                                   nil];
    
    // Get the key bits.
    status = SecItemCopyMatching((CFDictionaryRef)queryAttr, (CFTypeRef *)&publicKeyData);
    
    if (status != errSecSuccess)
        [NSException raise:NSInternalInconsistencyException
                    format:@"Problem during public key export; status == %d.", status];
    
    NSData *asn1PublicKey = [self asn1EncodePublicKey:publicKeyData];
    [publicKeyData release];
    
    return asn1PublicKey;
}

// Credits to Berin Lautenbach's "Importing an iPhone RSA public key into a Java app" -- http://blog.wingsofhermes.org/?p=42
// Helper function for ASN.1 encoding
size_t encodeLength(unsigned char * buf, size_t length);
size_t encodeLength(unsigned char * buf, size_t length) {
    
    // encode length in ASN.1 DER format
    if (length < 128) {
        buf[0] = length;
        return 1;
    }
    
    size_t i = (length / 256) + 1;
    buf[0] = i + 0x80;
    for (size_t j = 0 ; j < i; ++j) {
        buf[i - j] = length & 0xFF;
        length = length >> 8;
    }
    
    return i + 1;
}

+ (NSData *)asn1EncodePublicKey:(NSData *)publicKey {
    
    static const unsigned char _encodedRSAEncryptionOID[15] = {
        /* Sequence of length 0xd made up of OID followed by NULL */
        0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00
        
    };
    
    NSMutableData *encKey = [NSMutableData data];
    unsigned char builder[15];
    int bitstringEncLength;
    
    // When we get to the bitstring - how will we encode it?
    if  ([publicKey length] + 1 < 128)
        bitstringEncLength = 1;
    else
        bitstringEncLength = (([publicKey length] + 1) / 256 ) + 2;
    
    // Overall we have a sequence of a certain length
    builder[0] = 0x30;    // ASN.1 encoding representing a SEQUENCE
                          // Build up overall size made up of -
                          // size of OID + size of bitstring encoding + size of actual key
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength + [publicKey length];
    size_t j = encodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j +1];
    
    // First part of the sequence is the OID
    [encKey appendBytes:_encodedRSAEncryptionOID
                 length:sizeof(_encodedRSAEncryptionOID)];
    
    // Now add the bitstring
    builder[0] = 0x03;
    j = encodeLength(&builder[1], [publicKey length] + 1);
    builder[j+1] = 0x00;
    [encKey appendBytes:builder length:j + 2];
    
    // Now the actual key
    [encKey appendData:publicKey];
    
    return encKey;
}

@end
