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
//  UITableView(PearlReloadItems)
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
@interface UITableView(PearlReloadItems)

/**
 * oldItems and newItems should be row items in the given section.
 */
- (void)reloadSection:(NSInteger)section from:(NSOrderedSetOrArrayType)oldItems to:(NSOrderedSetOrArrayType)newItems;
- (void)reloadSection:(NSInteger)section from:(NSOrderedSetOrArrayType)oldItems to:(NSOrderedSetOrArrayType)newItems
     withRowAnimation:(UITableViewRowAnimation)animation;

/**
 * oldSections and newSections should be sections, where a section is a collection of row items.
 */
- (void)reloadSectionsFrom:(NSOrderedSetOrArrayType)oldSections to:(NSOrderedSetOrArrayType)newSections;
- (void)reloadSectionsFrom:(NSOrderedSetOrArrayType)oldSections to:(NSOrderedSetOrArrayType)newSections
          withRowAnimation:(UITableViewRowAnimation)animation;

@end
