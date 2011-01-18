//
//  WebUtils.m
//  iLibs
//
//  Created by Maarten Billemont on 18/01/11.
//  Copyright 2011 lhunath (Maarten Billemont). All rights reserved.
//

#import "WebUtils.h"


@implementation WebUtils

+ (NSString *)urlEncode:(NSString *)value {
    
    return [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL,
                                                                      CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                      kCFStringEncodingUTF8)) autorelease];
}

@end
