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


@interface NSString (PearlKeyChain)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
/** Create a signature for this object using the assymetric key in the given tag.
 *
 * The method checks the amount of bytes in the object to guess at what it is.
 * If the object looks like a known hash (MD5, SHA1), a signature is created using appropriate ASN.1 padding and PKCS1 padding.
 * Otherwise, the object is PKCS1 padded and signed.  This assumes the object is a DER-encoded ASN.1 DigestInfo.
 */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag;
/** Create a signature for this object using the given padding strategy and the assymetric key in the given tag. */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding;
#endif

@end

@interface NSData (PearlKeyChain)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
/** Create a signature for this object using the assymetric key in the given tag.
 *
 * The method checks the amount of bytes in the object to guess at what it is.
 * If the object looks like a known hash (MD5, SHA1), a signature is created using appropriate ASN.1 padding and PKCS1 padding.
 * Otherwise, the object is PKCS1 padded and signed.  This assumes the object is a DER-encoded ASN.1 DigestInfo.
 */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag;
/** Create a signature for this object using the given padding strategy and the assymetric key in the given tag. */
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding;
#endif

@end

@interface PearlKeyChain : NSObject {
@private

}

/** Add or update an item in the keychain.
 * 
 * @param query A query dictionary to use for searching an existing keychain item to update.  Should contain a kSecClass and one or more of kSecAttr and kSecMatch.
 * @param attributes A dictionary mapping the attributes (kSecAttr) and values (kSecValue) to their new content.
 */
+ (OSStatus)addOrUpdateItemForQuery:(NSDictionary *)query withAttributes:(NSDictionary *)attributes;

/** Delete an item from the keychain.
 * 
 * @param query A query dictionary to use for searching an existing keychain item to update.  Should contain a kSecClass and one or more of kSecAttr and kSecMatch.
 */
+ (OSStatus)deleteItemForQuery:(NSDictionary *)query;

/** Convenience method for creating a keychain query.
 * 
 * @param kSecClassValue A value of the kSecClass enum.
 * @param kSecAttrDictionary A dictionary indicating what attribute values to search for.  Keys should be values of the kSecAttr enum.
 * @param kSecMatchDictionary A dictionary indicating how the search should be performed or refined.  Keys should be values of the kSecMatch enum.
 */
+ (NSDictionary *)createQueryForClass:(CFTypeRef)kSecClassValue
                           attributes:(NSDictionary *)kSecAttrDictionary
                              matches:(NSDictionary *)kSecMatchDictionary;

/** Retrieve an item from the keychain.
 * 
 * @param query The attributes to use for finding the item.
 */
+ (OSStatus)findItemForQuery:(NSDictionary *)query into:(id*)result;

/** Run a query on the keychain and return the (first) found item in the form of the given return type.
 * 
 * @param query A query dictionary to use for searching the item in the keychain.
 * @param kSecReturn The return type (kSecReturn) indicating how the item that was found should be returned.
 * @return The item in the type defined by the return type, or nil if the item could not be found.
 */
+ (id)runQuery:(NSDictionary *)query returnType:(CFTypeRef)kSecReturn;

/** Return a reference to the (first) keychain item that matches the query.
 *
 * @param query A query dictionary to use for searching the item in the keychain.
 */
+ (id)itemForQuery:(NSDictionary *)query;

/** Return the (first) keychain item that matches the query as a data object that is independant from the keychain.
 *
 * @param query A query dictionary to use for searching the item in the keychain.
 */
+ (NSData *)persistentItemForQuery:(NSDictionary *)query;

/** Return the attributes of the (first) keychain item that matches the query.
 *
 * @param query A query dictionary to use for searching the item in the keychain.
 */
+ (NSDictionary *)attributesOfItemForQuery:(NSDictionary *)query;

/** Return the value data of the (first) keychain item that matches the query.
 *
 * @param query A query dictionary to use for searching the item in the keychain.
 */
+ (NSData *)dataOfItemForQuery:(NSDictionary *)query;

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
/** Generate a new key pair in the keychain and tag it with the given tag. */
+ (BOOL)generateKeyPairWithTag:(NSString *)tag;

/** Return the public key of the key pair in the keychain that was generated with the given tag. */
+ (NSData *)publicKeyWithTag:(NSString *)tag;
#endif

@end
