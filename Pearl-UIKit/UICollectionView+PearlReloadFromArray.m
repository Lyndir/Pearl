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

#import "UICollectionView+PearlReloadFromArray.h"

@implementation UICollectionView(PearlReloadFromArray)

- (void)reloadItemsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section {

    NSMutableArray *workArray = [fromArray mutableCopy];

    [self performBatchUpdates:^{
        // First remove deleted rows.
        for (NSInteger index = (NSInteger)[workArray count] - 1; index >= 0; --index) {
            id row = workArray[(NSUInteger)index];
            if (![toArray containsObject:row]) {
                [self deleteItemsAtIndexPaths:@[ [NSIndexPath indexPathForRow:index inSection:section] ]];
                [workArray removeObjectAtIndex:(NSUInteger)index];
            }
        }

        // Then add inserted rows.
        for (NSUInteger index = 0; index < [toArray count]; ++index) {
            id row = toArray[index];
            if (![workArray containsObject:row]) {
                [self insertItemsAtIndexPaths:@[ [NSIndexPath indexPathForRow:(NSInteger)index inSection:section] ]];
                [workArray insertObject:row atIndex:MIN( [workArray count], index )];
            }
        }

        // Then shuffle around moved rows.
        for (NSUInteger index = 0; index < [workArray count]; ++index) {
            id row = workArray[index];
            NSUInteger toIndex = [toArray indexOfObject:row];
            if (toIndex != index)
                [self moveItemAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)[fromArray indexOfObject:row] inSection:section]
                              toIndexPath:[NSIndexPath indexPathForRow:(NSInteger)toIndex inSection:section]];
        }
    }              completion:nil];
}

@end
