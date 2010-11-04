//
//  NSString_NSArrayFormat.m
//  iLibs
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "NSString_NSArrayFormat.h"


@implementation NSString (NSArrayFormat)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*) arguments;
{
    char *argList = (char *)malloc(sizeof(id) * [arguments count]);
    [arguments getObjects:(id *)argList];
    NSString* result = [[[NSString alloc] initWithFormat:format arguments:argList] autorelease];
    free(argList);
    return result;
}

@end
