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
//  PearlCryptUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import "PearlCryptUtils.h"
#import "PearlLogger.h"

@implementation NSString(PearlKeyChain)

#if TARGET_OS_IPHONE

- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag {

    return [[self dataUsingEncoding:NSUTF8StringEncoding] signWithAssymetricKeyChainKeyFromTag:tag];
}

- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding {

    return [[self dataUsingEncoding:NSUTF8StringEncoding] signWithAssymetricKeyChainKeyFromTag:tag usePadding:padding];
}

#endif

@end

@implementation NSData(PearlKeyChain)

#if TARGET_OS_IPHONE

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

    NSDictionary *queryAttr = [NSDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassKey, (__bridge id)kSecClass,
            [[tag stringByAppendingString:@"-priv"] dataUsingEncoding:NSUTF8StringEncoding],
                                             (__bridge id)kSecAttrApplicationTag,
            (__bridge id)kSecAttrKeyTypeRSA, (__bridge id)kSecAttrKeyType,
            (id)kCFBooleanTrue,              (__bridge id)kSecReturnRef,
            nil];

    SecKeyRef privateKey = nil;
    OSStatus status = SecItemCopyMatching( (__bridge CFDictionaryRef)queryAttr, (CFTypeRef *)&privateKey );
    if (status != errSecSuccess || privateKey == nil) {
        err(@"During key lookup: %@", NSStringFromErrSec( status ));
        return nil;
    }


    // Malloc a buffer to hold signature.
    size_t signedHashBytesSize = SecKeyGetBlockSize( privateKey );
    uint8_t *signedHashBytes = calloc( signedHashBytesSize, sizeof(uint8_t) );
    if (!signedHashBytes) {
        err(@"Couldn't allocate signed hash bytes: %@", errstr());
        return nil;
    }

    // Sign the SHA1 hash.
    status = SecKeyRawSign( privateKey, padding,
            self.bytes, self.length,
            signedHashBytes, &signedHashBytesSize );
    CFRelease( privateKey );
    if (status != errSecSuccess) {
        err(@"During data signing: %@", NSStringFromErrSec( status ));
        free( signedHashBytes );
        return nil;
    }

    // Build up signed SHA1 blob.
    NSData *signedData = [NSData dataWithBytes:signedHashBytes length:signedHashBytesSize];
    free( signedHashBytes );

    return signedData;
}

#endif

@end

@implementation PearlKeyChain

+ (NSString *)deviceIdentifier {

    static NSString *deviceIdentifierString = nil;
    if (deviceIdentifierString)
        return deviceIdentifierString;

    static NSDictionary *query = nil;
    if (!query)
        query = [self createQueryForClass:kSecClassGenericPassword
                               attributes:[NSDictionary dictionaryWithObjectsAndKeys:
#if TARGET_OS_IPHONE
                                       (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly, kSecAttrAccessible,
                                       #endif
                                       @"deviceIdentifier",                                 kSecAttrAccount,
                                       @"com.lyndir.Pearl",                                 kSecAttrService,
                                       nil]
                                  matches:nil];

    NSData *deviceIdentifier = [self dataOfItemForQuery:query];
    if (!deviceIdentifier)
        [self addOrUpdateItemForQuery:query
                       withAttributes:[NSDictionary dictionaryWithObject:deviceIdentifier = [[PearlCodeUtils randomUUID]
                               dataUsingEncoding:NSUTF8StringEncoding]
                                                                  forKey:(__bridge id)kSecValueData]];

    return deviceIdentifierString = [[NSString alloc] initWithBytes:deviceIdentifier.bytes length:deviceIdentifier.length
                                                           encoding:NSUTF8StringEncoding];
}

+ (OSStatus)updateItemForQuery:(NSDictionary *)query withAttributes:(NSDictionary *)attributes {

    OSStatus status = SecItemUpdate( (__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes );
    trc(@"SecItemUpdate(%@, %@) = %@", query, attributes, NSStringFromErrSec( status ));
    if (status != noErr)
    err(@"While updating keychain item: %@: %@",
    query, NSStringFromErrSec( status ));

    return status;
}

+ (OSStatus)setData:(NSData *)data ofItemForQuery:(NSDictionary *)query {

    return [self addOrUpdateItemForQuery:query withAttributes:[NSDictionary dictionaryWithObject:data forKey:(__bridge id)kSecValueData]];
}

+ (OSStatus)addOrUpdateItemForQuery:(NSDictionary *)query withAttributes:(NSDictionary *)attributes {

    OSStatus status = SecItemUpdate( (__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes );
    trc(@"SecItemUpdate(%@, %@) = %@", query, attributes, NSStringFromErrSec( status ));
    if (status == errSecItemNotFound) {
        NSMutableDictionary *newItem = [query mutableCopy];
        [newItem addEntriesFromDictionary:attributes];

        status = SecItemAdd( (__bridge CFDictionaryRef)newItem, NULL );
        trc(@"SecItemAdd(%@) = %@", newItem, NSStringFromErrSec( status ));
        if (status != noErr)
        err(@"While adding keychain item: %@: %@", query, NSStringFromErrSec( status ));
    }
    else if (status != noErr)
    err(@"While updating keychain item: %@: %@", query, NSStringFromErrSec( status ));

    return status;
}

+ (OSStatus)deleteItemForQuery:(NSDictionary *)query {

    OSStatus status = SecItemDelete( (__bridge CFDictionaryRef)query );
    trc(@"SecItemDelete(%@) = %@", query, NSStringFromErrSec( status ));
    if (status != noErr && status != errSecItemNotFound)
    err(@"While deleting keychain item: %@: %@",
    query, NSStringFromErrSec( status ));

    return status;
}

+ (OSStatus)findItemForQuery:(NSDictionary *)query into:(id *)result {

    CFTypeRef cfResult = NULL;
    OSStatus status = SecItemCopyMatching( (__bridge CFDictionaryRef)query, &cfResult );
    *result = (__bridge_transfer id)cfResult;
    trc(@"SecItemCopyMatching(%@) = %@, result: %@", query, NSStringFromErrSec( status ), *result);

    return status;
}

+ (NSDictionary *)createQueryForClass:(CFTypeRef)kSecClassValue
                           attributes:(NSDictionary *)kSecAttrDictionary
                              matches:(NSDictionary *)kSecMatchDictionary {

    if (![kSecAttrDictionary count])
    wrn(@"No attributes when creating keychain query.");

    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:(__bridge id)kSecClassValue forKey:(__bridge id)kSecClass];
    [query addEntriesFromDictionary:kSecAttrDictionary];
    [query addEntriesFromDictionary:kSecMatchDictionary];

    return query;
}

+ (id)runQuery:(NSDictionary *)query returnType:(CFTypeRef)kSecReturn {

    NSMutableDictionary *dataQuery = [query mutableCopy];
    [dataQuery setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturn];

    id result = nil;
    OSStatus status = [self findItemForQuery:dataQuery into:&result];
    if (status != noErr && status != errSecItemNotFound)
    wrn(@"While querying keychain for: %@: %@",
    dataQuery, NSStringFromErrSec( status ));

    return result;
}

+ (id)itemForQuery:(NSDictionary *)query {

    return [self runQuery:query returnType:kSecReturnRef];
}

+ (NSData *)persistentItemForQuery:(NSDictionary *)query {

    if (![query count]) {
        wrn(@"Missing query.");
        return nil;
    }

    return (NSData *)[self runQuery:query returnType:kSecReturnPersistentRef];
}

+ (NSDictionary *)attributesOfItemForQuery:(NSDictionary *)query {

    return (NSDictionary *)[self runQuery:query returnType:kSecReturnAttributes];
}

+ (NSData *)dataOfItemForQuery:(NSDictionary *)query {

    if (![query count]) {
        wrn(@"Missing query.");
        return nil;
    }

    return (NSData *)[self runQuery:query returnType:kSecReturnData];
}

+ (BOOL)generateKeyPairWithTag:(NSString *)tag {

#if TARGET_OS_IPHONE
    NSDictionary *privKeyAttr = [NSDictionary dictionaryWithObjectsAndKeys:
            [[tag stringByAppendingString:@"-priv"] dataUsingEncoding:NSUTF8StringEncoding],
                    (__bridge id)kSecAttrApplicationTag,
            nil];
    NSDictionary *pubKeyAttr = [NSDictionary dictionaryWithObjectsAndKeys:
            [[tag stringByAppendingString:@"-pub"] dataUsingEncoding:NSUTF8StringEncoding],
                    (__bridge id)kSecAttrApplicationTag,
            nil];
#endif
    NSDictionary *keyPairAttr = [NSDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecAttrKeyTypeRSA, (__bridge id)kSecAttrKeyType,
            [NSNumber numberWithInt:1024],   (__bridge id)kSecAttrKeySizeInBits,
            (id)kCFBooleanTrue,              (__bridge id)kSecAttrIsPermanent,
            #if TARGET_OS_IPHONE
            privKeyAttr,                     (__bridge id)kSecPrivateKeyAttrs,
            pubKeyAttr,                      (__bridge id)kSecPublicKeyAttrs,
            #else
                                   [tag dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
#endif
            nil];

    OSStatus status = SecKeyGeneratePair( (__bridge CFDictionaryRef)keyPairAttr, nil, nil );
    if (status != errSecSuccess) {
        err(@"During key generation: %@", NSStringFromErrSec( status ));
        return NO;
    }

    return YES;
}

+ (NSData *)publicKeyWithTag:(NSString *)tag {

    NSData *publicKeyData = nil;
#if TARGET_OS_IPHONE
    NSData *applicationTag = [[NSString stringWithFormat:@"%@-pub", tag] dataUsingEncoding:NSUTF8StringEncoding];
#else
    NSData *applicationTag = [tag dataUsingEncoding:NSUTF8StringEncoding];
#endif
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassKey,       (__bridge id)kSecClass,
            applicationTag,                  (__bridge id)kSecAttrApplicationTag,
            (__bridge id)kSecAttrKeyTypeRSA, (__bridge id)kSecAttrKeyType,
            (__bridge id)kCFBooleanTrue,     (__bridge id)kSecReturnData,
            nil];

    // Get the key bits.
    CFTypeRef cfResult = NULL;
    OSStatus status = SecItemCopyMatching( (__bridge CFDictionaryRef)query, &cfResult );
    publicKeyData = (__bridge_transfer id)cfResult;
    if (status != errSecSuccess) {
        err(@"During public key export: %@", NSStringFromErrSec( status ));
        return nil;
    }

    return [PearlCryptUtils derEncodeRSAKey:publicKeyData];
}

@end
