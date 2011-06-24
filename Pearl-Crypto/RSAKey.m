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
#import "Pearl-Crypto.h"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <openssl/err.h>
#include <openssl/ssl.h>

#define rsaKey ((RSA *)_key)
#define rsaKeyIn ((RSA **)&_key)


@implementation RSAKey
@synthesize isPublicKey = _isPublicKey;

static NSString *toHexString(id object) {
    
    if (NSNullToNil(object) == nil)
        return nil;
    
    if ([object isKindOfClass:[NSData class]])
        return [object encodeHex];
    
    if ([object isKindOfClass:[NSString class]])
        return object;
    
    err(@"Cannot convert to hex: %@", object);
    return nil;
}

static NSUInteger typeOfDigest(PearlDigest digest) {

    switch (digest) {
        case PearlDigestMD5:
            return NID_md5;
        case PearlDigestSHA1:
            return NID_sha1;
        case PearlDigestSHA256:
            return NID_sha256;
        case PearlDigestSHA384:
            return NID_sha384;
        case PearlDigestSHA512:
            return NID_sha512;
        case PearlDigestRIPEMD160:
            return NID_ripemd160;
    }
    
    err(@"Unsupported digest: %d", digest);
    return 0;
}

- (id)init {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = NO;
    
    _key = RSA_generate_key(1024, RSA_F4, NULL, NULL);
    
    if (!rsaKey) {
        [self release];
        return nil;
    }
    
    return self;
}

- (void)dealloc {
    
    if (rsaKey)
        RSA_free(rsaKey);

    [super dealloc];
}

- (id)initPrivateKeyWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = NO;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }

    BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->d), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (![self isValid]) {
        [self release];
        return nil;
    }

    return self;
}

- (id)initPrivateKeyWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = NO;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }
    
    rsaKey->n = BN_bin2bn(modulus.bytes, modulus.length, NULL);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    rsaKey->d = BN_bin2bn(exponent.bytes, exponent.length, NULL);

    if (![self isValid]) {
        [self release];
        return nil;
    }
    
    return self;
}

- (id)initPrivateKeyWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent
                            primeP:(NSString *)hexPrimeP primeQ:(NSString *)hexPrimeQ {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = NO;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }

    BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->d), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->p), [hexPrimeP cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->q), [hexPrimeQ cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (![self isValid]) {
        [self release];
        return nil;
    }
    
    return self;
}

- (id)initPrivateKeyWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent
                               primeP:(NSData *)primeP primeQ:(NSData *)primeQ {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = NO;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }

    rsaKey->n = BN_bin2bn(modulus.bytes, modulus.length, NULL);
    BN_hex2bn(&(rsaKey->e), [@"10001" cStringUsingEncoding:NSUTF8StringEncoding]);
    rsaKey->d = BN_bin2bn(exponent.bytes, exponent.length, NULL);
    rsaKey->p = BN_bin2bn(primeP.bytes, primeP.length, NULL);
    rsaKey->q = BN_bin2bn(primeQ.bytes, primeQ.length, NULL);
    
    if (![self isValid]) {
        [self release];
        return nil;
    }

    return self;
}

- (id)initPublicKeyWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = YES;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }
    
    BN_hex2bn(&(rsaKey->n), [hexModulus cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&(rsaKey->e), [hexExponent cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (![self isValid]) {
        [self release];
        return nil;
    }

    return self;
}

- (id)initPublicKeyWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent {
    
    if (!(self = [super init]))
        return nil;
    
    self.isPublicKey = YES;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }

    rsaKey->n = BN_bin2bn(modulus.bytes, modulus.length, NULL);
    rsaKey->e = BN_bin2bn(exponent.bytes, exponent.length, NULL);
    
    if (![self isValid]) {
        [self release];
        return nil;
    }
    
    return self;
}

- (id)initWithDERKey:(NSData *)derEncodedKey isPublic:(BOOL)isPublicKey {
    
    if (!(self = [super init]))
        return nil;
    
    if ((self.isPublicKey = isPublicKey)) {
        const unsigned char *derEncodedBytes = (const unsigned char *)derEncodedKey.bytes;
        _key = d2i_RSAPublicKey(NULL, &derEncodedBytes, derEncodedKey.length);
    } else {
        BIO *b = BIO_new(BIO_s_mem());
        BIO_write(b, derEncodedKey.bytes, derEncodedKey.length);
        _key = PEM_read_bio_RSAPrivateKey(b, rsaKeyIn, NULL, NULL);
    }
    
    if (!rsaKey || ![self isValid]) {
        [self release];
        return nil;
    }
    
	return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    if (!(self = [super init]))
        return nil;
    
    _key = RSA_new();
    if (!rsaKey) {
        [self release];
        return nil;
    }

    NSString *n, *e, *d, *p, *q;
    if ((n = toHexString([dictionary objectForKey:@"n"])))
        BN_hex2bn(&(rsaKey->n), [n cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((e = toHexString([dictionary objectForKey:@"e"])))
        BN_hex2bn(&(rsaKey->e), [e cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((d = toHexString([dictionary objectForKey:@"d"])))
        BN_hex2bn(&(rsaKey->d), [d cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((p = toHexString([dictionary objectForKey:@"p"])))
        BN_hex2bn(&(rsaKey->p), [p cStringUsingEncoding:NSUTF8StringEncoding]);
    if ((q = toHexString([dictionary objectForKey:@"q"])))
        BN_hex2bn(&(rsaKey->q), [q cStringUsingEncoding:NSUTF8StringEncoding]);
    self.isPublicKey = (d == nil);

    if (![self isValid]) {
        [self release];
        return nil;
    }

    return self;
}

- (RSAKey *)toPublicKey {
    
    if (self.isPublicKey)
        return self;
    
    return [[[RSAKey alloc] initPublicKeyWithHexModulus:[self modulus] exponent:[self publicExponent]] autorelease];
}

- (int)maxSize {
    
    return RSA_size(rsaKey);
}

- (BOOL)isValid {
    
    if (self.isPublicKey || !rsaKey->p)
        // Cannot use check_key on public keys or private keys without known p & q.
        return [[self modulus] length] && [[self exponent] length];
    
	int check = RSA_check_key(rsaKey);
    
    if (check == 0)
        return NO;
    if (check > 0)
        return YES;
    
    ERR_print_errors_fp(stderr);
    return NO;
}

- (NSString *)modulus {
    
    return [NSString stringWithCString:BN_bn2hex(rsaKey->n) encoding:NSUTF8StringEncoding];
}

- (NSString *)exponent {
    
    if (self.isPublicKey)
        return [NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding];
    else
        return [NSString stringWithCString:BN_bn2hex(rsaKey->d) encoding:NSUTF8StringEncoding];

}

- (NSString *)publicExponent {
    
    return [NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:5];

    if (rsaKey->n)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->n) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"n"];
    if (rsaKey->e)
        [representation setObject:[[NSString stringWithCString:BN_bn2hex(rsaKey->e) encoding:NSUTF8StringEncoding] decodeHex]
                           forKey:@"e"];
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
    unsigned char *buffer = (unsigned char *) malloc(RSA_size(rsaKey));
    
    if (self.isPublicKey)
        length = RSA_public_encrypt(data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);
    else
        length = RSA_private_encrypt(data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);
    
    if (length > 0)
        return [NSData dataWithBytesNoCopy:buffer length:length];
    
    ERR_print_errors_fp(stderr);
    return nil;
}

- (NSData *)decrypt:(NSData *)data {
    
    int length;
    unsigned char *buffer = (unsigned char *) malloc(RSA_size(rsaKey));
    
    if (self.isPublicKey)
        length = RSA_public_decrypt(data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);
    else
        length = RSA_private_decrypt(data.length, data.bytes, buffer, rsaKey, RSA_PKCS1_PADDING);
    
    if (length > 0)
        return [NSData dataWithBytesNoCopy:buffer length:length];
    
    ERR_print_errors_fp(stderr);
    return nil;
}

- (NSData *)sign:(NSData *)message hashWith:(PearlDigest)digest {
    
    NSUInteger length;
    unsigned char *buffer = (unsigned char *) malloc(RSA_size(rsaKey));
    
    if (!RSA_sign(typeOfDigest(digest), message.bytes, message.length, buffer, &length, rsaKey)) {
        ERR_print_errors_fp(stderr);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:buffer length:length];
}

- (NSData *)signRaw:(NSData *)asn1OctetString {
    
    NSUInteger length;
    unsigned char *buffer = (unsigned char *) malloc(RSA_size(rsaKey));
    
    if (!RSA_sign_ASN1_OCTET_STRING(0, asn1OctetString.bytes, asn1OctetString.length, buffer, &length, rsaKey)) {
        ERR_print_errors_fp(stderr);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:buffer length:length];
}

@end
