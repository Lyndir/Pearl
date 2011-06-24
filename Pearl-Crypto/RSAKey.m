/*!
 @file RSAKey.m
 @copyright Copyright (c) 2011 Radtastical, Inc.
 @copyright Copyright (c) 2011 Lhunath, Pearl
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "RSAKey.h"
#import "CryptUtils.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <openssl/err.h>
#include <openssl/ssl.h>

#define rsaKey ((RSA *)_key)
#define rsaKeyIn ((RSA **)&_key)


@interface RSAKey ()

+ (NSString *)toHexString:(id)object;

@end

@implementation RSAKey
@synthesize isPublicKey = _isPublicKey;

- (id)initPublic:(BOOL)isPublicKey {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = isPublicKey;
    _key = RSA_generate_key(1024, RSA_F4, NULL, NULL);
    
    return self;
}

- (id)initWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent isPublic:(BOOL)isPublicKey {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = isPublicKey;
    _key = RSA_new();
    if (hexModulus)
        BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    if (hexExponent) {
        if (self.isPublicKey)
            BN_hex2bn(&(rsaKey->e), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);
        else {
            BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
            BN_hex2bn(&(rsaKey->d), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }
    
    return self;
}

- (id)initWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent isPublic:(BOOL)isPublicKey {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = isPublicKey;
    _key = RSA_new();
    if (modulus)
        rsaKey->n = BN_bin2bn([modulus bytes], [modulus length], NULL);
    if (exponent) {
        if (self.isPublicKey)
            rsaKey->e = BN_bin2bn([exponent bytes], [exponent length], NULL);
        else
            rsaKey->d = BN_bin2bn([exponent bytes], [exponent length], NULL);
    }
    
    return self;
}

- (id)initWithDERKey:(NSData *)derEncodedKey isPublic:(BOOL)isPublicKey {
    
    if (!(self = [super init]))
        return nil;
    
    if ((self.isPublicKey = isPublicKey)) {
        const unsigned char *buffer;
        buffer = (const unsigned char *) derEncodedKey.bytes;
        _key = d2i_RSAPublicKey(NULL, &buffer, derEncodedKey.length);
    } else {
        BIO *b = BIO_new(BIO_s_mem());
        BIO_write(b, derEncodedKey.bytes, derEncodedKey.length);
        _key = PEM_read_bio_RSAPrivateKey(b, rsaKeyIn, NULL, NULL);
    }
    
    if (!rsaKey) {
        [self release];
        return nil;
    }
    
	return self;
}

- (id)initWithDictionary:(NSDictionary *) dictionary isPublic:(BOOL)isPublicKey {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = isPublicKey;
    _key = RSA_new();
    NSString *n, *e, *d, *p, *q;
    if ((n = [RSAKey toHexString:[dictionary objectForKey:@"n"]]))
        BN_hex2bn(&(rsaKey->n), [n cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((e = [RSAKey toHexString:[dictionary objectForKey:@"e"]]))
        BN_hex2bn(&(rsaKey->e), [e cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((d = [RSAKey toHexString:[dictionary objectForKey:@"d"]]))
        BN_hex2bn(&(rsaKey->d), [d cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((p = [RSAKey toHexString:[dictionary objectForKey:@"p"]]))
        BN_hex2bn(&(rsaKey->p), [p cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((q = [RSAKey toHexString:[dictionary objectForKey:@"q"]]))
        BN_hex2bn(&(rsaKey->q), [q cStringUsingEncoding:NSUTF8StringEncoding]);
    
    return self;
}

+ (NSString *)toHexString:(id)object {
    
    if ([object isKindOfClass:[NSData class]])
        return [object encodeHex];
    
    if ([object isKindOfClass:[NSString class]])
        return object;
    
    return nil;
}

- (int) maxSize {
    
    return RSA_size(rsaKey);
}

- (int) check {
    
	return RSA_check_key(rsaKey);
}

- (NSString *)modulus {
    
    return [NSString stringWithCString:BN_bn2hex(rsaKey->n) encoding:NSUTF8StringEncoding];
}

- (NSString *)exponent {
    
    return [NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:5];

    if (rsaKey->n)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->n) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"n"];
    if (rsaKey->e)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"n"];
    if (rsaKey->d)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->d) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"d"];
    if (rsaKey->p)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->p) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"p"];
    if (rsaKey->q)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->q) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"q"];
    
    return representation;
}

- (NSString *)description {
    
    return [[self dictionaryRepresentation] description];
}

- (NSData *)encodeDER {
    
    NSUInteger length;
	unsigned char *buffer;
    
    if (self.isPublicKey) {
        length = i2d_RSAPublicKey(rsaKey, NULL);
        buffer = (unsigned char *) malloc(length);
        i2d_RSAPublicKey(rsaKey, &buffer);
    } else {
        length = i2d_RSAPrivateKey(rsaKey, NULL);
        buffer = (unsigned char *) malloc(length);
        i2d_RSAPrivateKey(rsaKey, &buffer);
    }
    
	return [NSData dataWithBytesNoCopy:buffer length:length];
}

- (NSData *)encrypt:(NSData *)data {
    
    NSUInteger length;
    NSUInteger maxSize = RSA_size(rsaKey);
    unsigned char *buffer = (unsigned char *) malloc(maxSize * sizeof(char));
    
    if (self.isPublicKey)
        length = RSA_public_encrypt([data length], [data bytes], buffer, rsaKey, RSA_PKCS1_PADDING);
    else
        length = RSA_private_encrypt([data length], [data bytes], buffer, rsaKey, RSA_PKCS1_PADDING);
    
    if (length > 0)
        return [NSData dataWithBytesNoCopy:buffer length:length];
    
    ERR_print_errors_fp(stderr);
    return nil;
}

- (NSData *)decrypt:(NSData *)data {
    
    int length;
    NSUInteger maxSize = RSA_size(rsaKey);
    unsigned char *buffer = (unsigned char *) malloc(maxSize * sizeof(char));
    
    RSA *typedKey = rsaKey;
    if (self.isPublicKey)
        length = RSA_public_decrypt([data length], [data bytes], buffer, rsaKey, RSA_PKCS1_PADDING);
    else
        length = RSA_private_decrypt([data length], [data bytes], buffer, typedKey, RSA_PKCS1_PADDING);
    
    if (length > 0)
        return [NSData dataWithBytesNoCopy:buffer length:length];
    
    ERR_print_errors_fp(stderr);
    return nil;
}

@end
