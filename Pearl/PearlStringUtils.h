/**
 * Copyright Maarten Billemont (http://www.lhunath.com, lhunath@lyndir.com)
 *
 * See the enclosed file LICENSE for license information (LGPLv3). If you did
 * not receive this file, see http://www.gnu.org/licenses/lgpl-3.0.txt
 *
 * @author   Maarten Billemont <lhunath@lyndir.com>
 * @license  http://www.gnu.org/licenses/lgpl-3.0.txt
 */

//
//  StringUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

#define PearlString(format, ...) \
    [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define PearlLocalize(key, ...) \
    PearlString([[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil], ##__VA_ARGS__)
#define PearlLocalizeTable(tableName, key, ...) \
    PearlString([[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:tableName], ##__VA_ARGS__)

/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the right side. */
NSString *RPad(const NSString* string, NSUInteger l);
/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the left side. */
NSString *LPad(const NSString* string, NSUInteger l);
/** Generate a string where the ordinal suffix of the given number is appended to the given prefix. */
NSString *AppendOrdinalPrefix(const NSInteger number, const NSString* prefix);

NSArray *NumbersRanging(double min, double max, double step, NSNumberFormatterStyle style);

@interface PearlStringUtils : NSObject {
}

@end
