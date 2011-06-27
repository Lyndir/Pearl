//
//  CryptUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface NSString (KeyChain)

/** Create a signature for this object using the assymetric key in the given tag.
 *
 * The method checks the amount of bytes in the object to guess at what it is.
 * If the object looks like a known hash (MD5, SHA1), a signature is created using appropriate ASN.1 padding and PKCS1 padding.
 * Otherwise, the object is PKCS1 padded and signed.  This assumes the object is a DER-encoded ASN.1 DigestInfo.
 */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag;
/** Create a signature for this object using the given padding strategy and the assymetric key in the given tag. */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding;

@end

@interface NSData (KeyChain)

/** Create a signature for this object using the assymetric key in the given tag.
 *
 * The method checks the amount of bytes in the object to guess at what it is.
 * If the object looks like a known hash (MD5, SHA1), a signature is created using appropriate ASN.1 padding and PKCS1 padding.
 * Otherwise, the object is PKCS1 padded and signed.  This assumes the object is a DER-encoded ASN.1 DigestInfo.
 */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag;
/** Create a signature for this object using the given padding strategy and the assymetric key in the given tag. */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding;

@end

@interface KeyChain : NSObject {
@private

}

+ (BOOL)generateKeyPairWithTag:(NSString *)tag;
+ (NSData *)publicKeyWithTag:(NSString *)tag;

@end
