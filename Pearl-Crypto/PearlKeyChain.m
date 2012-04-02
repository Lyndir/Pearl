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
//  PearlCryptUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <CommonCrypto/CommonHMAC.h>

#import "PearlKeyChain.h"
#import "PearlCryptUtils.h"
#import "PearlLogger.h"


@implementation NSString (PearlKeyChain)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] signWithAssymetricKeyChainKeyFromTag:tag];
}

- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] signWithAssymetricKeyChainKeyFromTag:tag usePadding:padding];
}
#endif

@end

@implementation NSData (PearlKeyChain)

#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag {
    
    switch ([self length]) {
        case 16:
            return [self signWithAssymetricKeyChainKeyFromTag:tag usePadding:kSecPaddingPKCS1MD5];
        case 20:
            return [self signWithAssymetricKeyChainKeyFromTag:tag usePadding:kSecPaddingPKCS1SHA1];
        default:
            return [self signWithAssymetricKeyChainKeyFromTag:tag usePadding:kSecPaddingPKCS1];
    }
}

- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding {
    
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
        err(@"During key lookup: %@", NSStringFromErrSec(status));
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
        err(@"During data signing: %@", NSStringFromErrSec(status));
        return nil;
    }
    
    // Build up signed SHA1 blob.
    NSData *signedData = [NSData dataWithBytes:signedHashBytes length:signedHashBytesSize];
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedData;
}
#endif

@end

@implementation PearlKeyChain

+ (OSStatus)addOrUpdateItemForQuery:(NSDictionary *)query withAttributes:(NSDictionary *)attributes {
    
    OSStatus status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributes);
    if (status == errSecItemNotFound) {
        NSMutableDictionary *newItem = [[query mutableCopy] autorelease];
        [newItem addEntriesFromDictionary:attributes];
        
        status = SecItemAdd((CFDictionaryRef)newItem, NULL);
        if (status != noErr)
            err(@"While adding keychain item: %@: %@",
                newItem, NSStringFromErrSec(status));
    } else if (status != noErr)
        err(@"While updating keychain item: %@ with attributes: %@: %@",
            query, attributes, NSStringFromErrSec(status));

    return status;
}

+ (OSStatus)deleteItemForQuery:(NSDictionary *)query {
    
    OSStatus status = SecItemDelete((CFDictionaryRef)query);
    if (status != noErr && status != errSecItemNotFound)
        err(@"While looking for keychain item: %@: %@",
            query, NSStringFromErrSec(status));
    
    return status;
}

+ (OSStatus)findItemForQuery:(NSDictionary *)query into:(id*)result {
    
    return SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)result);
}

+ (NSDictionary *)createQueryForClass:(CFTypeRef)kSecClassValue
                           attributes:(NSDictionary *)kSecAttrDictionary
                              matches:(NSDictionary *)kSecMatchDictionary {
    
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:kSecClassValue forKey:kSecClass];
    [query addEntriesFromDictionary:kSecAttrDictionary];
    [query addEntriesFromDictionary:kSecMatchDictionary];
    
    return query;
}

+ (id)runQuery:(NSDictionary *)query returnType:(CFTypeRef)kSecReturn {
    
    NSMutableDictionary *dataQuery = [[query mutableCopy] autorelease];
    [dataQuery setObject:[NSNumber numberWithBool:YES] forKey:kSecReturn];
    
    id result = nil;
    OSStatus status = [self findItemForQuery:dataQuery into:&result];
    if (status != noErr && status != errSecItemNotFound)
        wrn(@"While querying keychain for: %@: %@",
            dataQuery, NSStringFromErrSec(status));
    
    return result;
}

+ (id)itemForQuery:(NSDictionary *)query {
    
    return [self runQuery:query returnType:kSecReturnRef];
}

+ (NSData *)persistentItemForQuery:(NSDictionary *)query {
    
    return (NSData *)[self runQuery:query returnType:kSecReturnPersistentRef];
}

+ (NSDictionary *)attributesOfItemForQuery:(NSDictionary *)query {
    
    return (NSDictionary *)[self runQuery:query returnType:kSecReturnAttributes];
}

+ (NSData *)dataOfItemForQuery:(NSDictionary *)query {
    
    return (NSData *)[self runQuery:query returnType:kSecReturnData];
}

+ (BOOL)generateKeyPairWithTag:(NSString *)tag {
    
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NSDictionary *privKeyAttr   = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString stringWithFormat:@"%@-priv", tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   nil];
    NSDictionary *pubKeyAttr    = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString stringWithFormat:@"%@-pub", tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   nil];
#endif
    NSDictionary *keyPairAttr   = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   [NSNumber numberWithInt:1024],   (id)kSecAttrKeySizeInBits,
                                   (id)kCFBooleanTrue,              (id)kSecAttrIsPermanent,
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
                                   privKeyAttr,                     (id)kSecPrivateKeyAttrs,
                                   pubKeyAttr,                      (id)kSecPublicKeyAttrs,
#else
                                   [tag dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
#endif
                                   nil];
    
    OSStatus status = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, nil, nil);
    if (status != errSecSuccess) {
        err(@"During key generation: %@", NSStringFromErrSec(status));
        return NO;
    }
    
    return YES;
}

+ (NSData *)publicKeyWithTag:(NSString *)tag {
    
    NSData *publicKeyData = nil;
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NSData *applicationTag = [[NSString stringWithFormat:@"%@-pub", tag] dataUsingEncoding:NSUTF8StringEncoding];
#else
    NSData *applicationTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
#endif
    NSDictionary *queryAttr     = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecClassKey,                (id)kSecClass,
                                   applicationTag,                  (id)kSecAttrApplicationTag,
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   (id)kCFBooleanTrue,              (id)kSecReturnData,
                                   nil];
    
    // Get the key bits.
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)queryAttr, (CFTypeRef *)&publicKeyData);
    if (status != errSecSuccess) {
        err(@"During public key export: %@", NSStringFromErrSec(status));
        return nil;
    }
    
    [publicKeyData autorelease];
    return [PearlCryptUtils derEncodeRSAKey:publicKeyData];
}

@end
