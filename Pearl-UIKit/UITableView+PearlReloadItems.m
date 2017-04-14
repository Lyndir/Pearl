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

#import "UITableView+PearlReloadItems.h"
#import "NSMutableSet+Pearl.h"

@implementation UITableView(PearlReloadItems)

- (void)reloadSection:(NSInteger)section from:(NSOrderedSetOrArrayType)oldItems to:(NSOrderedSetOrArrayType)newItems {

    [self reloadSection:section from:oldItems to:newItems withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSection:(NSInteger)section from:(NSOrderedSetOrArrayType)oldItems to:(NSOrderedSetOrArrayType)newItems
     withRowAnimation:(UITableViewRowAnimation)animation {

    if ([oldItems isEqual:newItems])
        return;

    @try {
        NSMutableOrderedSet *workSet = [[oldItems orderedSet] mutableCopy];
        [self beginUpdates];

        // First remove deleted rows.
        for (NSUInteger row = [workSet count] - 1; row < [workSet count]; --row) {
            id item = workSet[row];
            if (![newItems containsObject:item]) {
                [self deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row inSection:section] ]
                            withRowAnimation:animation];
                [workSet removeObjectAtIndex:row];
            }
        }

        // Then add inserted rows.
        for (NSUInteger row = 0; row < [newItems count]; ++row) {
            id item = newItems[row];
            if (![workSet containsObject:item]) {
                [self insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:(NSInteger)row inSection:section] ]
                            withRowAnimation:animation];
                [workSet insertObject:item atIndex:MIN( [workSet count], row )];
            }
        }

        // Then shuffle around moved rows.
        for (NSUInteger row = 0; row < [workSet count]; ++row) {
            id item = workSet[row];
            NSUInteger toRow = [newItems indexOfObject:item];
            if (toRow != row)
                [self moveRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)[oldItems indexOfObject:item] inSection:section]
                             toIndexPath:[NSIndexPath indexPathForRow:(NSInteger)toRow inSection:section]];
        }

        [self endUpdates];
    }
    @catch (NSException *e) {
        wrn( @"Exception while reloading rows for table.  Falling back to a full reload.\n%@", [e fullDescription] );
        @try {
            [self reloadData];
        }
        @catch (NSException *e) {
            err( @"Exception during fallback reload.\n%@", [e fullDescription] );
        }
    }
}

- (void)reloadSectionsFrom:(NSOrderedSetOrArrayType)oldSections to:(NSOrderedSetOrArrayType)newSections {

    [self reloadSectionsFrom:oldSections to:newSections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSectionsFrom:(NSOrderedSetOrArrayType)oldSections to:(NSOrderedSetOrArrayType)newSections
          withRowAnimation:(UITableViewRowAnimation)animation {

    if ([oldSections isEqual:newSections])
        return;

    @try {
        [self beginUpdates];

        NSMutableSet *fromItems = [NSMutableSet set];
        NSMutableArray *deletePaths = [NSMutableArray array];
        NSMutableDictionary *movedPaths = [NSMutableDictionary dictionary];
        for (NSUInteger section = 0; section < [oldSections count]; ++section) {
            NSArray *fromRows = oldSections[section];
            for (NSUInteger row = 0; row < [fromRows count]; ++row) {
                id fromItem = fromRows[row];
                [fromItems addObject:fromItem];
                NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSIndexPath *toIndexPath = [self indexPathForItem:fromItem inSections:newSections];

                if (!toIndexPath)
                    [deletePaths addObject:fromIndexPath];

                else if (fromIndexPath != toIndexPath)
                    movedPaths[fromIndexPath] = toIndexPath;
            }
        }

        // First remove deleted rows.
        [self deleteRowsAtIndexPaths:deletePaths withRowAnimation:animation];

        // Then add inserted rows.
        for (NSUInteger section = 0; section < [newSections count]; ++section) {
            NSArray *toRows = newSections[section];
            for (NSUInteger row = 0; row < [toRows count]; ++row) {
                if (![fromItems tryRemoveObject:toRows[row]])
                    [self insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row inSection:section] ]
                                withRowAnimation:animation];
            }
        }

        // Then shuffle around moved rows.
        [movedPaths enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *fromIndexPath, NSIndexPath *toIndexPath, BOOL *stop) {
            [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        }];

        [self endUpdates];
    }
    @catch (NSException *e) {
        wrn( @"Exception while reloading sections for table.  Falling back to a full reload.\n%@", [e fullDescription] );
        @try {
            [self reloadData];
        }
        @catch (NSException *e) {
            err( @"Exception during fallback reload.\n%@", [e fullDescription] );
        }
    }
}

- (NSIndexPath *)indexPathForItem:(id)item inSections:(id<NSOrderedSetOrArray>)sections {

    NSUInteger section = 0;
    for (id rows in sections) {
        NSUInteger row = [rows indexOfObject:item];

        if (row != NSNotFound)
            return [NSIndexPath indexPathForRow:row inSection:section];

        ++section;
    }

    return nil;
}

@end
