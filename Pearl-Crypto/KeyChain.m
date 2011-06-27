//
//  CryptUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <CommonCrypto/CommonHMAC.h>

#import "KeyChain.h"
#import "CryptUtils.h"
#import "Logger.h"


@implementation NSString (KeyChain)

- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] signWithAssymetricKeyChainKeyFromTag:tag];
}

- (NSData *)signWithAssymetricKeyChainKeyFromTag:(NSString *)tag usePadding:(SecPadding)padding {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] signWithAssymetricKeyChainKeyFromTag:tag usePadding:padding];
}

@end

@implementation NSData (KeyChain)

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
        err(@"Problem during key lookup; status == %d.", status);
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
        err(@"Problem during data signing; status == %d.", status);
        return nil;
    }
    
    // Build up signed SHA1 blob.
    NSData *signedData = [NSData dataWithBytes:signedHashBytes length:signedHashBytesSize];
    if (signedHashBytes)
        free(signedHashBytes);
    
    return signedData;
}

@end

@implementation KeyChain

+ (BOOL)generateKeyPairWithTag:(NSString *)tag {
    
    NSDictionary *privKeyAttr   = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString stringWithFormat:@"%@-priv",  tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   nil];
    NSDictionary *pubKeyAttr    = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [[NSString stringWithFormat:@"%@-pub",   tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   nil];
    NSDictionary *keyPairAttr   = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   [NSNumber numberWithInt:1024],   (id)kSecAttrKeySizeInBits,
                                   (id)kCFBooleanTrue,              (id)kSecAttrIsPermanent,
                                   privKeyAttr,                     (id)kSecPrivateKeyAttrs,
                                   pubKeyAttr,                      (id)kSecPublicKeyAttrs,
                                   nil];
    
    OSStatus status = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, nil, nil);
    if (status != errSecSuccess) {
        err(@"Problem during key generation; status == %d.", status);
        return NO;
    }
    
    return YES;
}

+ (NSData *)publicKeyWithTag:(NSString *)tag {
    
    NSData *publicKeyData = nil;
    NSDictionary *queryAttr     = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)kSecClassKey,                (id)kSecClass,
                                   [[NSString stringWithFormat:@"%@-pub",  tag] dataUsingEncoding:NSUTF8StringEncoding],
                                   (id)kSecAttrApplicationTag,
                                   (id)kSecAttrKeyTypeRSA,          (id)kSecAttrKeyType,
                                   (id)kCFBooleanTrue,              (id)kSecReturnData,
                                   nil];
    
    // Get the key bits.
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)queryAttr, (CFTypeRef *)&publicKeyData);
    if (status != errSecSuccess) {
        err(@"Problem during public key export; status == %d.", status);
        return nil;
    }
    
    [publicKeyData autorelease];
    return [CryptUtils derEncodeRSAKey:publicKeyData];
}

@end
