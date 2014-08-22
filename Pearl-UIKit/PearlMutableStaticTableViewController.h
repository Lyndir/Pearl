//
// Created by Maarten Billemont on 2014-08-21.
// Copyright (c) 2014 Lyndir. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PearlMutableStaticTableViewController : UITableViewController

@property(nonatomic, readonly) NSArray *allCells;

- (void)updateCellsHiding:(NSArray *)hideCells showing:(NSArray *)showCells animated:(BOOL)animated;

@end
