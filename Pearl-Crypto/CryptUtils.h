//
//  CryptUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

#ifndef kCipherAlgorithm
#define kCipherAlgorithm    kCCAlgorithmAES128
#endif
#ifndef kCipherKeySize
#define kCipherKeySize      kCCKeySizeAES128
#endif
#ifndef kCipherBlockSize
#define kCipherBlockSize    8
#endif

NSString *NSStringFromCCCryptorStatus(CCCryptorStatus status);
NSString *NSStringFromErrSec(OSStatus status);

@interface NSString (CryptUtils)

/** Encrypt this plain-text string object with the given key. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

@end

@interface NSData (CryptUtils)

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

@interface CryptUtils : NSObject

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha;

+ (NSData *)derEncodeRSAKey:(NSData *)publicKey;

@end
