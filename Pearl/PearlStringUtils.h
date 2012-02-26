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
//  StringUtils.h
//  Pearl
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

#define l(key, ...) \
    [NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil] , ##__VA_ARGS__, nil]

#define lt(tableName, key, ...) \
    [NSString stringWithFormat:[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:tableName] , ##__VA_ARGS__, nil]

/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the right side. */
NSString* RPad(const NSString* string, NSUInteger l);
/** Generate a string that contains the given string but pads it to the given length if it is less by adding spaces on the left side. */
NSString* LPad(const NSString* string, NSUInteger l);
/** Generate a string where the ordinal suffix of the given number is appended to the given prefix. */
NSString* AppendOrdinalPrefix(const NSInteger number, const NSString* prefix);

NSArray* NumbersRanging(double min, double max, double step, NSNumberFormatterStyle style);

@interface PearlStringUtils : NSObject {
@private
    
}

@end
