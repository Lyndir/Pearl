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
//  WebUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 18/01/11.
//  Copyright 2011 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlWebUtils.h"


@implementation PearlWebUtils

+ (NSString *)urlEncode:(NSString *)value {
    
    return [NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, NULL,
                                                                      CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),
                                                                      kCFStringEncodingUTF8)) autorelease];
}

@end
