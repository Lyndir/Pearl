/*!
 @file RSAKey.h
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

#import <Foundation/Foundation.h>

#import "CodeUtils.h"


@interface RSAKey : NSObject
{
    void                            *_key;
    BOOL                            _isPublicKey;
}

@property (readwrite, assign) BOOL  isPublicKey;

- (id)init;
- (id)initPrivateKeyWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent;
- (id)initPrivateKeyWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent;
- (id)initPrivateKeyWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent
                            primeP:(NSString *)hexPrimeP primeQ:(NSString *)hexPrimeQ;
- (id)initPrivateKeyWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent
                               primeP:(NSData *)primeP primeQ:(NSData *)primeQ;
- (id)initPublicKeyWithHexModulus:(NSString *)hexModulus exponent:(NSString *)hexExponent;
- (id)initPublicKeyWithBinaryModulus:(NSData *)modulus exponent:(NSData *)exponent;
- (id)initWithDEREncodedPKCS1:(NSData *)derEncodedKey isPublic:(BOOL)isPublicKey;
- (id)initWithDEREncodedPKCS12:(NSData *)derEncodedKey passphrase:(NSString *)passphrase isPublic:(BOOL)isPublicKey;
- (id)initWithPEMEncodedPKCS12:(NSData *)pemEncodedKey passphrase:(NSString *)passphrase isPublic:(BOOL)isPublicKey;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (RSAKey *)publicKey;
- (NSData *)derExportPKCS1;
- (NSData *)derExportPKCS12WithName:(NSString *)friendlyName encryptedWithPassphrase:(NSString *)passphrase;
- (NSData *)pemExport:(NSString *)friendlyName encryptedWithPassphrase:(NSString *)passphrase;

- (int)maxSize;
- (BOOL)isValid;
- (NSString *)modulus;
- (NSString *)exponent;
- (NSString *)publicExponent;
- (NSDictionary *)dictionaryRepresentation;

- (NSData *)encrypt:(NSData *) data;
- (NSData *)decrypt:(NSData *) data;
- (NSData *)sign:(NSData *)message hashWith:(PearlDigest)digest;
- (NSData *)signRaw:(NSData *)asn1OctetString;

@end
