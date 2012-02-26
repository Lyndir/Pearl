/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  StringUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlStringUtils.h"
#import "PearlStrings.h"


NSString* RPad(const NSString* string, const NSUInteger l) {

    NSMutableString *newString = [string mutableCopy];
    while (newString.length < l)
        [newString appendString:@" "];

    return newString;
}


NSString* LPad(const NSString* string, const NSUInteger l) {

    NSMutableString *newString = [string mutableCopy];
    while (newString.length < l)
        [newString insertString:@" " atIndex:0];

    return newString;
}


NSString* AppendOrdinalPrefix(const NSInteger number, const NSString* prefix) {

    NSString *suffix = [PearlStrings get].timeDaySuffix;
    if(number % 10 == 1 && number != 11)
        suffix = [PearlStrings get].timeDaySuffixOne;
    else if(number % 10 == 2 && number != 12)
        suffix = [PearlStrings get].timeDaySuffixTwo;
    else if(number % 10 == 3 && number != 13)
        suffix = [PearlStrings get].timeDaySuffixThree;

    return [NSString stringWithFormat:@"%@%@", prefix, suffix];
}

NSArray* NumbersRanging(double min, double max, double step, NSNumberFormatterStyle style) {

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = style;
    NSMutableArray *numbers = [NSMutableArray arrayWithCapacity:(NSUInteger)((max - min) / step)];
    for (double n = min; n <= max; n += step)
        [numbers addObject:[formatter stringFromNumber:[NSNumber numberWithDouble:n]]];
    [formatter release];

    return numbers;
}

@implementation PearlStringUtils

@end
