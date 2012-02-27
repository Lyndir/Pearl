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


@interface NSString (PearlKeyChain)

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

@interface NSData (PearlKeyChain)

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

/** Generate a new key pair in the keychain and tag it with the given tag. */
+ (BOOL)generateKeyPairWithTag:(NSString *)tag;

/** Return the public key of the key pair in the keychain that was generated with the given tag. */
+ (NSData *)publicKeyWithTag:(NSString *)tag;

@end
