/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

#ifdef PEARL_WITH_SCRYPT

#import <scrypt/crypto_scrypt.h>
#import <scrypt/scryptenc.h>

@interface PearlSCrypt ()


@end

@implementation PearlSCrypt
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
    self.maximumMemory             = maximumMemory;
    self.time                      = time;

    return self;
}

static BOOL checkResult(int resultCode) {

    if (resultCode == 0)
        return YES;

    switch (resultCode) {
        case 1:
            err(@"Error determining amount of available memory: getrlimit or sysctl(hw.usermem) failed");
            break;
        case 2:
            err(@"Error reading clocks: clock_getres or clock_gettime failed");
            break;
        case 3:
            err(@"Error computing derived key");
            break;
        case 4:
            err(@"Error reading salt: could not read salt from /dev/urandom");
            break;
        case 5:
            err(@"OpenSSL error");
            break;
        case 6:
            err(@"Error allocating memory: malloc failed");
            break;
        case 7:
            err(@"Input is not valid scrypt-encrypted block");
            break;
        case 8:
            err(@"Unrecognized scrypt format version");
            break;
        case 9:
            err(@"Decrypting file would require too much memory");
            break;
        case 10:
            err(@"Decrypting file would take too much CPU time");
            break;
        case 11:
            err(@"Passphrase is incorrect");
            break;
        case 12:
            err(@"Error writing output");
            break;
        case 13:
            err(@"Error reading input");
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

- (NSData *)deriveKeyWithLength:(NSUInteger)keyLength fromPassword:(NSData *)password usingSalt:(NSData *)salt {

    uint64_t N;
    uint32_t r, p;
    if (![self determineParametersN:&N r:&r p:&p])
        return nil;

    return [PearlSCrypt deriveKeyWithLength:keyLength fromPassword:password usingSalt:salt N:N r:r p:p];
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
