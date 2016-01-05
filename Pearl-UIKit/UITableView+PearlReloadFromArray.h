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
//  UITableView(PearlReloadFromArray)
//
//  Created by Maarten Billemont on 2014-05-21.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Automatically calculate the necessary row animations to transition from an old to a new set of items.
 *
 * NOTE: This code relies on the row items being unique in terms of -hash and -isEqual.
 */
@interface UITableView(PearlReloadFromArray)

/**
 * fromArray and toArray should be arrays of row items in the given section.
 */
- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section;
- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section
           withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * fromArray and toArray should be arrays of sections, where a section is an array of row items.
 */
- (void)reloadSectionsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray;
- (void)reloadSectionsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray
               withRowAnimation:(UITableViewRowAnimation)animation;

@end
