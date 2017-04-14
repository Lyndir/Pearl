//
// Created by Maarten Billemont on 2014-08-21.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import "PearlMutableStaticTableViewController.h"

@implementation PearlMutableStaticTableViewController {
    NSMutableOrderedSet<NSMutableOrderedSet *> *_allCellsBySection;
    NSMutableOrderedSet<NSMutableOrderedSet *> *_activeCellsBySection;
}

#pragma mark - Life

- (void)viewDidLoad {

    [super viewDidLoad];

    NSUInteger sections = (NSUInteger)[super numberOfSectionsInTableView:self.tableView];
    _allCellsBySection = [NSMutableOrderedSet orderedSetWithCapacity:sections];
    _activeCellsBySection = [NSMutableOrderedSet orderedSetWithCapacity:sections];
    for (NSUInteger section = 0; section < sections; ++section) {
        NSUInteger rows = (NSUInteger)[super tableView:self.tableView numberOfRowsInSection:section];
        NSMutableOrderedSet *allSectionCells = [NSMutableOrderedSet orderedSetWithCapacity:rows];
        NSMutableOrderedSet *activeSectionCells = [NSMutableOrderedSet orderedSetWithCapacity:rows];
        [_allCellsBySection addObject:allSectionCells];
        [_activeCellsBySection addObject:activeSectionCells];

        for (NSUInteger row = 0; row < rows; ++row) {
            UITableViewCell
                    *cell = [super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            [allSectionCells addObject:cell];
            [activeSectionCells addObject:cell];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_activeCellsBySection[(NSUInteger)section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return _activeCellsBySection[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [_activeCellsBySection count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
            break;
        case UITableViewCellEditingStyleDelete:
            [_activeCellsBySection[(NSUInteger)indexPath.section] removeObjectAtIndex:(NSUInteger)indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case UITableViewCellEditingStyleInsert:
            break;
    }
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {

    UITableViewCell *cell = _activeCellsBySection[(NSUInteger)sourceIndexPath.section][(NSUInteger)sourceIndexPath.row];
    [_activeCellsBySection[(NSUInteger)sourceIndexPath.section] removeObjectAtIndex:(NSUInteger)sourceIndexPath.row];
    [_activeCellsBySection[(NSUInteger)destinationIndexPath.section] insertObject:cell atIndex:(NSUInteger)sourceIndexPath.row];
    [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - State

- (NSOrderedSet *)allCellsBySection {

    return _allCellsBySection;
}

#pragma mark - Behavior

- (void)reloadCellsHiding:(NSOrderedSetOrArrayType)hideCells showing:(NSOrderedSetOrArrayType)showCells {

    [self updateCellsHiding:hideCells showing:showCells animation:UITableViewRowAnimationNone reloadData:YES];
}

- (void)updateCellsHiding:(NSOrderedSetOrArrayType)hideCells showing:(NSOrderedSetOrArrayType)showCells
                animation:(UITableViewRowAnimation)animation {

    [self updateCellsHiding:hideCells showing:showCells animation:animation reloadData:NO];
}

- (void)updateCellsHiding:(NSOrderedSetOrArrayType)hideCells showing:(NSOrderedSetOrArrayType)showCells
                animation:(UITableViewRowAnimation)animation reloadData:(BOOL)reloadData {

    NSOrderedSet *hideCellsSet = [hideCells orderedSet];
    NSOrderedSet *showCellsSet = [showCells orderedSet];

    if (!reloadData)
        [self.tableView beginUpdates];

    for (NSUInteger section = 0; section < [_activeCellsBySection count]; ++section) {
        NSMutableOrderedSet *activeSectionCells = _activeCellsBySection[section];
        NSMutableOrderedSet *oldSectionCells = [activeSectionCells copy];

        // Remove all the features in _activeSectionCells that need to be hidden.
        [activeSectionCells minusOrderedSet:hideCellsSet];

        // Add the features to _activeSectionCells that need to be shown (but only once).
        NSMutableOrderedSet *showSectionCells = [self->_allCellsBySection[section] mutableCopy];
        [showSectionCells intersectOrderedSet:showCellsSet];
        [activeSectionCells unionOrderedSet:showSectionCells];

        // Make the order of the cells in in _activeSectionCells match the original order in _allCellsBySection.
        [activeSectionCells sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSUInteger i1 = [self->_allCellsBySection[section] indexOfObject:obj1];
            NSUInteger i2 = [self->_allCellsBySection[section] indexOfObject:obj2];
            return i1 == i2? NSOrderedSame: i1 < i2? NSOrderedAscending: NSOrderedDescending;
        }];

        if (!reloadData)
            [self.tableView reloadSection:section from:oldSectionCells to:activeSectionCells withRowAnimation:animation];
    }

    if (reloadData)
        [self.tableView reloadData];
    else
        [self.tableView endUpdates];
}

@end
