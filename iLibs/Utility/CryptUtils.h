//
//  CryptUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface NSString (CryptUtils)

/** Generate an MD5 hash for the string. */
- (NSData *)hashWithMD5;
/** Generate a SHA-1 hash for the string. */
- (NSData *)hashWithSHA1;

/** Decode a hex-encoded string into bytes. */
- (NSData *)decodeHex;
/** Decode a base64-encoded string into bytes. */
- (NSData *)decodeBase64;

/** Encrypt this plain-text string object with the given key. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

@end

@interface NSData (CryptUtils)

- (NSData *)hashWithMD5;
- (NSData *)hashWithSHA1;
- (NSData *)saltWith:(NSData *)salt delimitor:(char)delimitor;

/** Create a string object by formatting the bytes as hexadecimal. */
- (NSString *)encodeHex;
/** Create a string object by formatting the bytes as base64. */
- (NSString *)encodeBase64;

/** Generate a data set whose bytes are the XOR operation between the bytes of this data object and those of the given otherData. */
- (NSData *)xorWith:(NSData *)otherData;

/** Encrypt this plain-data object using the given key, yielding an encrypted-data object. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

/** Decrypt this encrypted-data object using the given key, yielding a plain-data object. */
- (NSData *)decryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

/** Apply a symmetric crypto operation on the data using the given key and options.
 * @return A plain or encrypted object, depending on the operation applied. */
- (NSData *)doCipher:(CCOperation)encryptOrDecrypt withSymmetricKey:(NSData *)symmetricKey options:(CCOptions *)options;

/** Create a signature for this object using the assymetric key in the given tag.
 *
 * The method checks the amount of bytes in the object to guess at what it is.
 * If the object looks like a known hash (MD5, SHA1), a signature is created using appropriate ASN.1 padding and PKCS1 padding.
 * Otherwise, the object is PKCS1 padded and signed.  This assumes the object is a DER-encoded ASN.1 DigestInfo.
 */
- (NSData *)signWithAssymetricKeyFromTag:(NSString *)tag;
/** Create a signature for this object using the given padding strategy and the assymetric key in the given tag. */
- (NSData *)signWithAssymetricKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding;

@end

@interface CryptUtils : NSObject {
@private

}

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha;

+ (NSData *)generateKeyPairWithTag:(NSString *)tag;

+ (NSData *)asn1EncodePublicKey:(NSData *)publicKey;

@end
