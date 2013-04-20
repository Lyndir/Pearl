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
#define PearlCryptBlockSize     kCCBlockSizeAES128
#endif

__BEGIN_DECLS
NSString *NSStringFromCCCryptorStatus(CCCryptorStatus status);
NSString *NSStringFromErrSec(OSStatus status);
__END_DECLS

@interface NSString(PearlCryptUtils)

/** Encrypt this plain-text string object with the given key. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey padding:(BOOL)padding;

/** Encrypt this plain-text string object with the given key and options. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options;

@end

@interface NSData(PearlCryptUtils)

/** Encrypt this plain-data object using the given key, yielding an encrypted-data object. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey padding:(BOOL)padding;

/** Encrypt this plain-data object using the given key and options, yielding an encrypted-data object. */
- (NSData *)encryptWithSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options;

/** Decrypt this encrypted-data object using the given key, yielding a plain-data object. */
- (NSData *)decryptWithSymmetricKey:(NSData *)symmetricKey padding:(BOOL)padding;

/** Decrypt this encrypted-data object using the given key and options, yielding a plain-data object. */
- (NSData *)decryptWithSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options;

/** Apply a symmetric crypto operation on the data using the given key and options.
 * @return A plain or encrypted object, depending on the operation applied. */
- (NSData *)doCipher:(CCOperation)encryptOrDecrypt withSymmetricKey:(NSData *)symmetricKey options:(CCOptions)options;

@end

@interface PearlCryptUtils : NSObject

+ (NSString *)displayOTPWithKey:(NSData *)key factor:(NSData *)factor
                      otpLength:(NSUInteger)otpLength otpAlpha:(BOOL)otpAlpha;

+ (NSData *)derEncodeRSAKey:(NSData *)publicKey;

@end
