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
//  StringUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//


NSString *PearlString(NSString *format, ...) {

    va_list argList;
    va_start(argList, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:argList];
    va_end(argList);

    return string;
}

NSString *RPad(const NSString *string, const NSUInteger l) {

    NSMutableString *newString = [string mutableCopy];
    while (newString.length < l)
        [newString appendString:@" "];

    return newString;
}


NSString *LPad(const NSString *string, const NSUInteger l) {

    NSMutableString *newString = [string mutableCopy];
    while (newString.length < l)
        [newString insertString:@" " atIndex:0];

    return newString;
}


NSString *AppendOrdinalPrefix(const NSInteger number, const NSString *prefix) {

    NSString *suffix = [PearlStrings get].timeDaySuffix;
    if (number % 10 == 1 && number != 11)
        suffix = [PearlStrings get].timeDaySuffixOne;
    else
        if (number % 10 == 2 && number != 12)
            suffix = [PearlStrings get].timeDaySuffixTwo;
        else
            if (number % 10 == 3 && number != 13)
                suffix = [PearlStrings get].timeDaySuffixThree;

    return [NSString stringWithFormat:@"%@%@", prefix, suffix];
}

NSArray *NumbersRanging(double min, double max, double step, NSNumberFormatterStyle style) {

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = style;
    NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:(NSUInteger)((max - min) / step)];
    for (double n = min; n <= max; n += step)
        [numbers addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:n]]];

    return numbers;
}

@implementation NSString (PearlStringUtils)

- (NSString *)stringByDeletingMatchesOf:(NSString *)pattern {

    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0 error:&error];
    if (error) {
        err(@"Couldn't compile pattern: %@, reason: %@", pattern, error);
        return nil;
    }

    return [self stringByDeletingMatchesOfExpression:expression];
}

- (NSString *)stringByDeletingMatchesOfExpression:(NSRegularExpression *)expression {

    return [self stringByReplacingMatchesOfExpression:expression withTemplate:@""];
}

- (NSString *)stringByReplacingMatchesOf:(NSString *)pattern withTemplate:(NSString *)templ {

    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0 error:&error];
    if (error) {
        err(@"Couldn't compile pattern: %@, reason: %@", pattern, error);
        return nil;
    }

    return [self stringByReplacingMatchesOfExpression:expression withTemplate:templ];
}

- (NSString *)stringByReplacingMatchesOfExpression:(NSRegularExpression *)expression withTemplate:(NSString *)templ {

    return [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:templ];
}

@end
