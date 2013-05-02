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

__BEGIN_DECLS
extern NSString *PearlString(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);
extern NSAttributedString *PearlAttributeString(NSString *string, NSRange range, NSDictionary *attributes);
extern NSString *PearlLocalize(NSString *format, ...) NS_FORMAT_FUNCTION(1, 0);
extern NSString *PearlLocalizeTable(NSString *tableName, NSString *format, ...) NS_FORMAT_FUNCTION(2, 0);

extern NSString *PearlStringB(BOOL value);
extern NSString *PearlStringNSB(NSNumber *value);

/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the right side. */
extern NSString *RPad(const NSString *string, NSUInteger l);
/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the left side. */
extern NSString *LPad(const NSString *string, NSUInteger l);
/** Generate a string where the ordinal suffix of the given number is appended to the given prefix. */
extern NSString *AppendOrdinalPrefix(const NSInteger number, const NSString *prefix);

extern NSArray *NumbersRanging(double min, double max, double step, NSNumberFormatterStyle style);
__END_DECLS

@interface NSString(PearlStringUtils)

- (NSString *)stringByDeletingMatchesOf:(NSString *)pattern;
- (NSString *)stringByDeletingMatchesOfExpression:(NSRegularExpression *)expression;

- (NSString *)stringByReplacingMatchesOf:(NSString *)pattern withTemplate:(NSString *)templ;
- (NSString *)stringByReplacingMatchesOfExpression:(NSRegularExpression *)expression withTemplate:(NSString *)templ;

@end
