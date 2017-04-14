//
// Created by Maarten Billemont on 2014-08-21.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PearlMutableStaticTableViewController : UITableViewController

@property(nonatomic, readonly) NSOrderedSet<NSOrderedSet *> *allCellsBySection;

- (void)reloadCellsHiding:(NSOrderedSetOrArrayType)hideCells showing:(NSOrderedSetOrArrayType)showCells;
- (void)updateCellsHiding:(NSOrderedSetOrArrayType)hideCells showing:(NSOrderedSetOrArrayType)showCells
                animation:(UITableViewRowAnimation)animation;
- (void)updateCellsHiding:(NSOrderedSetOrArrayType)hideCells showing:(NSOrderedSetOrArrayType)showCells
                animation:(UITableViewRowAnimation)animation reloadData:(BOOL)reloadData;

@end
