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
//  UICollectionView(PearlReloadFromArray).h
//  UICollectionView(PearlReloadFromArray)
//
//  Created by lhunath on 2014-08-21.
//  Copyright, lhunath (Maarten Billemont) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Automatically calculate the necessary section and item animations to update the data in a dataSource.
 *
 * NOTE: This code relies on the row items being unique in terms of -hash and -isEqual.
 */
@interface UICollectionView(PearlReloadItems)

/**
 * Updates the dataSource collection to become the same as the newSections collection while animating the changes.
 *
 * @param dataSource This should be the collection that is backing your UICollectionViewDataSource delegate methods.
 * @param newSections A new collection of the same structure as the dataSource.
 * @param reloadItems A collection of dataSource items to reload OR the dataSource itself to reload all items.
 */
- (void)updateDataSource:(NSMutableOrderedSetOrArrayType)dataSource toSections:(NSOrderedSetOrArrayType)newSections
             reloadItems:(NSSetOrArrayType)reloadItems completion:(void ( ^ )(BOOL finished))completion;

@end
