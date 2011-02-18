//
//  CryptUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


/**
 * An exception that indicates decryption was attempted with an invalid key.
 */
@interface InvalidKeyException : NSException

+ (void)raise;

@end

@interface NSString (CryptUtils)

/** Generate an MD5 hash for the string. */
- (NSData *)md5Data;
/** Generate a hexadecimal encoded MD5 hash for the string. */
- (NSString *)md5;

/** Generate a SHA-1 hash for the string. */
- (NSData *)sha1Data;
/** Generate a hexadecimal encoded SHA-1 hash for the string. */
- (NSString *)sha1;

/** Encrypt this plain-text string object with the given key. */
- (NSData *)encryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

@end

@interface NSData (CryptUtils)

- (NSData *)md5;
- (NSData *)sha1;

/** Create a string object by formatting the bytes as hexadecimal. */
- (NSString *)hex;

/** Generate a data set whose bytes are the XOR operation between the bytes of this data object and those of the given otherData. */
- (NSData *)xor:(NSData *)otherData;

/** Encrypt this plain-data object using the given key, yielding an encrypted-data object. */
- (NSData *)encryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

/** Decrypt this encrypted-data object using the given key, yielding a plain-data object. */
- (NSData *)decryptWithKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

- (NSData *)doCipher:(CCOperation)encryptOrDecrypt withKey:(NSData *)symmetricKey options:(CCOptions *)options;

- (NSData *)signWithKeyFromTag:(NSString *)tag;

@end

@interface CryptUtils : NSObject {
@private

}

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha;

+ (NSData *)generateKeyPairWithTag:(NSString *)tag;

+ (NSData *)asn1EncodePublicKey:(NSData *)publicKey;

@end
