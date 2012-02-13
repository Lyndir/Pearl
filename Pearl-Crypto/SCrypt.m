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

#ifdef PEARL_WITH_SCRYPT
#import "SCrypt.h"
#import "ObjectUtils.h"
#import "Logger.h"
#import <scrypt/crypto_scrypt.h>
#import <scrypt/scryptenc.h>

@interface SCrypt ()


@end

@implementation SCrypt
@synthesize fractionOfAvailableMemory = _fractionOfAvailableMemory, maximumMemory = _maximumMemory, time = _time;

- (id)init {
    
    if (!(self = [self initWithMemoryFraction:0 maximum:0 time:0]))
        return nil;
    
    return self;
}

- (id)initWithMemoryFraction:(double)fractionOfAvailableMemory maximum:(NSUInteger)maximumMemory time:(double)time {
    
    if (!(self = [super init]))
        return nil;
    
    self.fractionOfAvailableMemory = fractionOfAvailableMemory;
    self.maximumMemory = maximumMemory;
    self.time = time;
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

static BOOL checkResult(NSUInteger resultCode) {
    
    if (resultCode == 0)
        return YES;
    
    switch (resultCode) {
        case 1:
            err("Error determining amount of available memory: getrlimit or sysctl(hw.usermem) failed");                                                                                                                                               
            break;
        case 2:
            err("Error reading clocks: clock_getres or clock_gettime failed");
            break;
        case 3:
            err("Error computing derived key");
            break;
        case 4:
            err("Error reading salt: could not read salt from /dev/urandom");
            break;
        case 5:
            err("OpenSSL error");
            break;
        case 6:
            err("Error allocating memory: malloc failed");
            break;
        case 7:
            err("Input is not valid scrypt-encrypted block");
            break;
        case 8:
            err("Unrecognized scrypt format version");
            break;
        case 9:
            err("Decrypting file would require too much memory");
            break;
        case 10:
            err("Decrypting file would take too much CPU time");
            break;
        case 11:
            err("Passphrase is incorrect");
            break;
        case 12:
            err("Error writing output");
            break;
        case 13:
            err("Error reading input");
            break;
    }
    
    return NO;
}

+ (NSData *)deriveKeyWithLength:(NSUInteger)keyLength fromPassword:(NSData *)password
                      usingSalt:(NSData *)salt N:(uint64_t)N r:(uint32_t)r p:(uint32_t)p {

    size_t outbuflen = keyLength;
    uint8_t *outbuf = malloc(outbuflen);
    if (crypto_scrypt(password.bytes, password.length,
                                   salt.bytes, salt.length, N, r, p,
                                   outbuf, outbuflen) < 0) {
        err(@"crypto_scrypt: %@", errstr());
        return nil;
    }
    
    return [NSData dataWithBytes:outbuf length:outbuflen];
}

- (BOOL)determineParametersN:(uint64_t *)N r:(uint32_t *)r p:(uint32_t *)p {
    
    int logN;
    if (!checkResult(pickparams(self.maximumMemory, self.fractionOfAvailableMemory, self.time,
                                  &logN, r, p)))
        return NO;
    
    *N = (uint64_t)(1) << logN;
    return YES;
}

- (NSData *)encrypt:(NSData *)plain withPassword:(NSData *)password {
    
    size_t outbuflen = plain.length + 128;
    uint8_t *outbuf = malloc(outbuflen);
    if (!checkResult(scryptenc_buf(plain.bytes, plain.length, outbuf, password.bytes, password.length,
                                   self.maximumMemory, self.fractionOfAvailableMemory, self.time)))
        return nil;
    
    return [NSData dataWithBytes:outbuf length:outbuflen];
}

- (NSData *)decrypt:(NSData *)encrypted withPassword:(NSData *)password {
    
    size_t outbuflen = encrypted.length;
    uint8_t *outbuf = malloc(outbuflen);
    if (!checkResult(scryptdec_buf(encrypted.bytes, encrypted.length, outbuf, &outbuflen, (uint8_t *)password.bytes, password.length,
                                   self.maximumMemory, self.fractionOfAvailableMemory, self.time)))
        return nil;
    
    return [NSData dataWithBytes:outbuf length:outbuflen];
}

@end
#endif
