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
//  NSObject+PearlExport.h
//  RedButton
//
//  Created by Maarten Billemont on 16/06/11.
//  Copyright 2011 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PearlExport)

- (id<NSCoding, NSCopying>)exportToCodable;
- (NSDictionary *)exportToDictionary;

+ (id<NSCoding, NSCopying>)exportToCodable:(id)object;
+ (NSDictionary *)exportToDictionary:(id)object;

@end
