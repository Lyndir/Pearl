//
//  NSString_NSArrayFormat.h
//  iLibs
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSArrayFormat)

/** Generate a string from the given printf(3)-style format by using the arguments in the given array as arguments to the format string. */
+ (id)stringWithFormat:(NSString *)format array:(NSArray*)  _arguments;

@end
