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
//  NSArray(Indexing)
//
//  Created by Maarten Billemont on 2012-08-24.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#if !defined(__IPHONE_6_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import <Foundation/Foundation.h>

// Fix modern ObjC bool in iOS 5: @YES, @NO
#if __has_feature(objc_bool)
#undef YES
#undef NO
#define YES __objc_yes
#define NO __objc_no
#endif

@interface NSArray (Indexing)

- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end

@interface NSMutableArray (Indexing)

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;

@end
#endif
