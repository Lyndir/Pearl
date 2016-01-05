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

#import "UITableView+PearlReloadFromArray.h"
#import "NSMutableSet+Pearl.h"

@implementation UITableView(PearlReloadFromArray)

- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section {

    [self reloadRowsFromArray:fromArray toArray:toArray inSection:section withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray inSection:(NSInteger)section
           withRowAnimation:(UITableViewRowAnimation)animation {

    if ([fromArray isEqualToArray:toArray])
        return;

    @try {
        NSMutableArray *workArray = [fromArray mutableCopy];
        [self beginUpdates];

        // First remove deleted rows.
        for (NSUInteger row = [workArray count] - 1; row < [workArray count]; --row) {
            id item = workArray[row];
            if (![toArray containsObject:item]) {
                [self deleteRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:row inSection:section] ]
                            withRowAnimation:animation];
                [workArray removeObjectAtIndex:row];
            }
        }

        // Then add inserted rows.
        for (NSUInteger row = 0; row < [toArray count]; ++row) {
            id item = toArray[row];
            if (![workArray containsObject:item]) {
                [self insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:(NSInteger)row inSection:section] ]
                            withRowAnimation:animation];
                [workArray insertObject:item atIndex:MIN( [workArray count], row )];
            }
        }

        // Then shuffle around moved rows.
        for (NSUInteger row = 0; row < [workArray count]; ++row) {
            id item = workArray[row];
            NSUInteger toRow = [toArray indexOfObject:item];
            if (toRow != row)
                [self moveRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)[fromArray indexOfObject:item] inSection:section]
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

- (void)reloadSectionsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray {

    [self reloadSectionsFromArray:fromArray toArray:toArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSectionsFromArray:(NSArray *)fromArray toArray:(NSArray *)toArray withRowAnimation:(UITableViewRowAnimation)animation {

    if ([fromArray isEqualToArray:toArray])
        return;

    @try {
        [self beginUpdates];

        NSMutableSet *fromItems = [NSMutableSet set];
        NSMutableArray *deletePaths = [NSMutableArray array];
        NSMutableDictionary *movedPaths = [NSMutableDictionary dictionary];
        for (NSUInteger section = 0; section < fromArray.count; ++section) {
            NSArray *fromRows = fromArray[section];
            for (NSUInteger row = 0; row < fromRows.count; ++row) {
                id fromItem = fromRows[row];
                [fromItems addObject:fromItem];
                NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                NSIndexPath *toIndexPath = [self indexPathForItem:fromItem inSectionsArray:toArray];

                if (!toIndexPath)
                    [deletePaths addObject:fromIndexPath];

                else if (fromIndexPath != toIndexPath)
                    movedPaths[fromIndexPath] = toIndexPath;
            }
        }

        // First remove deleted rows.
        [self deleteRowsAtIndexPaths:deletePaths withRowAnimation:animation];

        // Then add inserted rows.
        for (NSUInteger section = 0; section < toArray.count; ++section) {
            NSArray *toRows = toArray[section];
            for (NSUInteger row = 0; row < toRows.count; ++row) {
                if (![fromItems checkRemoveObject:toRows[row]])
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

- (NSIndexPath *)indexPathForItem:(id)item inSectionsArray:(NSArray *)sectionsArray {

    for (NSUInteger section = 0; section < sectionsArray.count; ++section) {
        NSArray *rowsArray = sectionsArray[section];
        NSUInteger row = [rowsArray indexOfObject:item];

        if (row != NSNotFound)
            return [NSIndexPath indexPathForRow:row inSection:section];
    }

    return nil;
}

@end
