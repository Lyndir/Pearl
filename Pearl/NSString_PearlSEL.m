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
//  NSString_PearlSEL.m
//  Pearl
//
//  Created by Maarten Billemont on 06/10/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "NSString_PearlSEL.h"


@implementation NSString (PearlSEL)

- (BOOL)isGetter {
    
    return ![self isSetter];
}


- (BOOL)isSetter {
    
    return [self hasPrefix:@"set"];
}


- (NSString *)getterToSetter {
    
    if ([self isSetter])
        return self;
    
    NSRange firstChar, rest;
    firstChar.location  = 0;
    firstChar.length    = 1;
    rest.location       = 1;
    rest.length         = self.length - 1;
    
    return [NSString stringWithFormat:@"set%@%@:",
            [[self substringWithRange:firstChar] uppercaseString],
            [self substringWithRange:rest]];
}


- (NSString *)setterToGetter {
    
    if ([self isGetter])
        return self;
    
    NSRange firstChar, rest;
    firstChar.location  = 3;
    firstChar.length    = 1;
    rest.location       = 4;
    rest.length         = self.length - 5;
    
    return [NSString stringWithFormat:@"%@%@",
            [[self substringWithRange:firstChar] lowercaseString],
            [self substringWithRange:rest]];
}

@end
