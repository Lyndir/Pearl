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

@interface RSAKey : NSObject
{
    void                            *_key;
    BOOL                            _isPublicKey;
}

@property (readwrite, assign) BOOL  isPublicKey;

- (id)initPublic:(BOOL)isPublicKey;
- (id)initWithModulus:(NSString *)modulus exponent:(NSString *)exponent isPublic:(BOOL)isPublicKey;
- (id)initWithDictionary:(NSDictionary *)dictionary isPublic:(BOOL)isPublicKey;
- (int)maxSize;
- (NSString *)modulus;
- (NSString *)exponent;
- (NSDictionary *)dictionaryRepresentation;
- (NSDictionary *)publicKeyDictionaryRepresentation;
- (NSData *)encryptWithPublicKey:(NSData *) data;
- (NSData *)encryptWithPrivateKey:(NSData *) data;
- (NSData *)decryptWithPublicKey:(NSData *) data;
- (NSData *)decryptWithPrivateKey:(NSData *) data;

@end
