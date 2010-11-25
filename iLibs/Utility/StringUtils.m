//
//  StringUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 05/11/09.
//  Copyright 2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "StringUtils.h"


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
    
    NSString *suffix = l(@"time.day.suffix");
    if(number % 10 == 1 && number != 11)
        suffix = l(@"time.day.suffix.one");
    else if(number % 10 == 2 && number != 12)
        suffix = l(@"time.day.suffix.two");
    else if(number % 10 == 3 && number != 13)
        suffix = l(@"time.day.suffix.three");
    
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
