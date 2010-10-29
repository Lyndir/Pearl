//
//  NSData_MBBase64.h
//  iLibs
//
//  http://www.cocoadev.com/index.pl?BaseSixtyFour
//

#import <Foundation/Foundation.h>


@interface NSData (MBBase64)

/**
 * Decode the given base64 encoded string into data.
 *
 * Padding '=' characters are optional. Whitespace is ignored.
 */
+ (id)dataWithBase64EncodedString:(NSString *)string;

/** Generate a base64 encoded string from this data. */
- (NSString *)base64Encoding;

@end
