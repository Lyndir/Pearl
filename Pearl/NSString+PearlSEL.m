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
//  NSString+PearlSEL.m
//  Pearl
//
//  Created by Maarten Billemont on 06/10/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//


@implementation NSString(PearlSEL)

- (BOOL)isGetter {

    return ![self isSetter];
}

- (BOOL)isSetter {

    static NSRegularExpression *setterPattern = nil;
    if (!setterPattern)
        setterPattern = [NSRegularExpression regularExpressionWithPattern:@"^set[[:upper:]]" options:0 error:nil];

    return [setterPattern numberOfMatchesInString:self options:0 range:NSMakeRange( 0, self.length )] > 0;
}

- (NSString *)getterToSetter {

    if ([self isSetter])
        return self;

    NSRange firstChar, rest;
    firstChar.location = 0;
    firstChar.length = 1;
    rest.location = 1;
    rest.length = self.length - 1;

    return [NSString stringWithFormat:@"set%@%@:",
                                      [[self substringWithRange:firstChar] uppercaseString],
                                      [self substringWithRange:rest]];
}

- (NSString *)setterToGetter {

    if ([self isGetter])
        return self;

    NSRange firstChar, rest;
    firstChar.location = 3;
    firstChar.length = 1;
    rest.location = 4;
    rest.length = self.length - 5;

    return [NSString stringWithFormat:@"%@%@",
                                      [[self substringWithRange:firstChar] lowercaseString],
                                      [self substringWithRange:rest]];
}

@end
