//
//  CodeUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//
//  See http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <CommonCrypto/CommonDigest.h>

#import "CodeUtils.h"
#import "Logger.h"

static const char CodeUtils_Base64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


@implementation NSString (CodeUtils)

- (NSData *)hashWith:(PearlDigest)digest {
    
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hashWith:digest];
}

- (NSData *)decodeHex {
    
    NSMutableData *data = [NSMutableData dataWithLength:self.length / 2];
    for (NSUInteger i = 0; i < self.length; i += 2) {
        NSString    *hex = [self substringWithRange:NSMakeRange(i, 2)];
        NSScanner   *scanner = [NSScanner scannerWithString:hex];
        NSUInteger  intValue;
        
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    
    return data;
}

- (NSData *)decodeBase64 {
    
	if (![self length])
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL) {
		decodingTable = malloc(256);
		if (decodingTable == NULL)
			return nil;
		
        memset(decodingTable, CHAR_MAX, 256);
		for (NSUInteger i = 0; i < 64; i++)
			decodingTable[(short)CodeUtils_Base64EncodingTable[i]] = i;
	}
	
	const char *characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)
        //  Not an ASCII string!
		return nil;
    
	char *bytes = malloc((([self length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
    
	NSUInteger length = 0, i = 0;
	while (YES)	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++) {
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
            
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX) {
                // Illegal character!
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1) {
            //  At least two characters are needed to produce one byte!
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end

@implementation NSData (CodeUtils)

- (NSString *)encodeHex {
    
    NSMutableString *hex = [NSMutableString stringWithCapacity:self.length * 2];
    for (NSUInteger i = 0; i < self.length; ++i)
        [hex appendFormat:@"%02hhx", ((char *)self.bytes)[i]];
    
    return hex;
}

- (NSString *)encodeBase64 {
    
	if ([self length] == 0)
		return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	
    NSUInteger length = 0, i = 0;
	while (i < [self length]) {
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = CodeUtils_Base64EncodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = CodeUtils_Base64EncodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = CodeUtils_Base64EncodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = CodeUtils_Base64EncodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

- (NSData *)hashWith:(PearlDigest)digest {
    
    switch (digest) {
        case PearlDigestMD5: {
            unsigned char result[CC_MD5_DIGEST_LENGTH];
            CC_MD5(self.bytes, self.length, result);
            
            return [NSData dataWithBytes:result length:sizeof(result)];
        }
        case PearlDigestSHA1: {
            unsigned char result[CC_SHA1_DIGEST_LENGTH];
            CC_SHA1(self.bytes, self.length, result);
            
            return [NSData dataWithBytes:result length:sizeof(result)];
        }
        case PearlDigestSHA256: {
            unsigned char result[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(self.bytes, self.length, result);
            
            return [NSData dataWithBytes:result length:sizeof(result)];
        }
        case PearlDigestSHA384: {
            unsigned char result[CC_SHA384_DIGEST_LENGTH];
            CC_SHA384(self.bytes, self.length, result);
            
            return [NSData dataWithBytes:result length:sizeof(result)];
        }
        case PearlDigestSHA512: {
            unsigned char result[CC_SHA512_DIGEST_LENGTH];
            CC_SHA512(self.bytes, self.length, result);
            
            return [NSData dataWithBytes:result length:sizeof(result)];
        }
    }
    
    err(@"Digest not supported: %d", digest);
    return nil;
}

- (NSData *)saltWith:(NSData *)salt delimitor:(char)delimitor {
    
    NSMutableData *saltedData = [self mutableCopy];
    [saltedData appendBytes:&delimitor length:1];
    [saltedData appendData:salt];
    
    return [saltedData autorelease];
}

- (NSData *)xorWith:(NSData *)otherData {
    
    if (self.length != otherData.length) {
        err(@"Input data must have the same length for an XOR operation to work.");
        return nil;
    }
    
    NSData *xorData = [self copy];
    for (NSUInteger b = 0; b < xorData.length; ++b)
        ((char *)xorData.bytes)[b] ^= ((char *)otherData.bytes)[b];
    
    return xorData;
}

@end
