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
//  NSString+PearlNSArrayFormat.h
//  Pearl
//
//  Created by Maarten Billemont on 28/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(PearlNSArrayFormat)

- (id)initWithFormat:(NSString *)format array:(NSArray *)arguments;

/** Generate a string from the given printf(3)-style format by using the arguments in the given array as arguments to the format string. */
+ (instancetype)stringWithFormat:(NSString *)format array:(NSArray *)arguments;

@end
