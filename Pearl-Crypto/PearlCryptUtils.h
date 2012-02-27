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
//  PearlCryptUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

#ifndef PearlCryptAlgorithm
#define PearlCryptAlgorithm     kCCAlgorithmAES128
#endif
#ifndef PearlCryptKeySize
#define PearlCryptKeySize       kCCKeySizeAES128
#endif
#ifndef PearlCryptBlockSize
#define PearlCryptBlockSize     8
#endif


@interface NSString (PearlCryptUtils)

/** Encrypt this plain-text string object with the given key. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey usePadding:(BOOL)usePadding;

@end

@interface NSData (PearlCryptUtils)

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

@interface PearlCryptUtils : NSObject

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha;

+ (NSData *)derEncodeRSAKey:(NSData *)publicKey;

@end
