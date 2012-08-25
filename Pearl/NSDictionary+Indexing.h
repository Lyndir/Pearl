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
//  NSDictionary(Indexing)
//
//  Created by Maarten Billemont on 2012-08-24.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#if !defined(__IPHONE_6_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import <Foundation/Foundation.h>

@interface  NSDictionary (Indexing)

- (id)objectForKeyedSubscript:(id)key;

@end

@interface  NSMutableDictionary (Indexing)

- (void)setObject:(id)object forKeyedSubscript:(id)key;

@end
#endif
