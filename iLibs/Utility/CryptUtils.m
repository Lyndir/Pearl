//
//  CryptUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "CryptUtils.h"
#import "Logger.h"

#define kCipherAlgorithm    kCCAlgorithmAES128
#define kCipherKeySize      kCCKeySizeAES128
#define kCipherBlockSize    8

static const char CryptUtils_Base64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@implementation NSString (CryptUtils)

- (NSData *)hashWithMD5 {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hashWithMD5];
}

- (NSData *)hashWithSHA1 {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hashWithSHA1];
}

- (NSData *)decodeHex {
    
    NSMutableData *data = [NSMutableData dataWithLength:self.length / 2];
    for (NSUInteger i = 0; i < self.length; i += 2) {
        NSString    *hex = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner   *scanner = [NSScanner scannerWithString:hex];
        NSUInteger  intValue;
        
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}

- (NSData *)decodeBase64 {
    
	if (![self length])
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL) {
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		
        memset(decodingTable, CHAR_MAX, 256);
		for (NSUInteger i = 0; i < 64; i++)
			decodingTable[(short)CryptUtils_Base64EncodingTable[i]] = i;
	}
	
	const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)
        //  Not an ASCII string!
		return nil;
    
	char *bytes = malloc((([self length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
    
	NSUInteger length = 0, i = 0;
	while (YES)	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++) {
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
            
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX) {
                // Illegal character!
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1) {
            //  At least two characters are needed to produce one byte!
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] encryptWithSymmetricKey:symmetricKey usePadding:usePadding];
}

@end

@implementation NSData (CryptUtils)

- (NSString *)encodeHex {
    
    NSMutableString *hex = [NSMutableString stringWithCapacity:self.length * 2];
    for (NSUInteger i = 0; i < self.length; ++i)
        [hex appendFormat:@"%02hhx", ((char *)self.bytes)[i]];
    
    return hex;
}

- (NSString *)encodeBase64 {
    
	if ([self length] == 0)
		return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	
    NSUInteger length = 0, i = 0;
	while (i < [self length]) {
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = CryptUtils_Base64EncodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = CryptUtils_Base64EncodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = CryptUtils_Base64EncodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = CryptUtils_Base64EncodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

- (NSData *)hashWithMD5 {
    
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(self.bytes, self.length, result);
    
    return [NSData dataWithBytes:result length:sizeof(result)];
}

- (NSData *)hashWithSHA1 {
    
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(self.bytes, self.length, result);
    
    return [NSData dataWithBytes:result length:sizeof(result)];
}

- (NSData *)saltWith:(NSData *)salt delimitor:(char)delimitor {
    
    NSMutableData *saltedData = [self mutableCopy];
    [saltedData appendBytes:&delimitor length:1];
    [saltedData appendData:salt];
    
    return [saltedData autorelease];
}

- (NSData *)xorWith:(NSData *)otherData {
    
    if (self.length != otherData.length) {
        err(@"Input data must have the same length for an XOR operation to work.");
        return nil;
    }
    
    NSData *xorData = [self copy];
    for (NSUInteger b = 0; b < xorData.length; ++b)
        ((char *)xorData.bytes)[b] ^= ((char *)otherData.bytes)[b];
    
    return xorData;
}

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
    if (status != errSecSuccess) {
        err(@"Problem during key generation; status == %d.", status);
        return nil;
    }
    
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
    
    if (status != errSecSuccess) {
        err(@"Problem during public key export; status == %d.", status);
        return nil;
    }
    
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
