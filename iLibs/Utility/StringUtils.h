//
//  StringUtils.h
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

#define l(key, ...) \
    [NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil] , ##__VA_ARGS__, nil]

/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the right side. */
NSString* RPad(const NSString* string, NSUInteger l);
/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the left side. */
NSString* LPad(const NSString* string, NSUInteger l);
/** Generate a string where the ordinal suffix of the given number is appended to the given prefix. */
NSString* AppendOrdinalPrefix(const NSInteger number, const NSString* prefix);

NSArray* NumbersRanging(double min, double max, double step, NSNumberFormatterStyle style);
