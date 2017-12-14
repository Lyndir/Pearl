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
//  UITableViewCell(PearlDequeue)
//
//  Created by Maarten Billemont on 2014-05-26.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell(PearlDeque)

+ (instancetype)templateCellFromTableView:(UITableView *)tableView;

+ (instancetype)dequeueCellFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueCellFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
                                    init:(void ( ^ )(__kindof UITableViewCell *cell))initBlock;

+ (void)registerNibCellWithTableView:(UITableView *)tableView;
+ (void)registerCellWithTableView:(UITableView *)tableView;
+ (void)registerCellWithTableView:(UITableView *)tableView usingNib:(UINib *)nib;

@end

@interface UITableViewHeaderFooterView(PearlDeque)

+ (instancetype)dequeueHeaderFooterFromTableView:(UITableView *)tableView;
+ (instancetype)dequeueHeaderFooterFromTableView:(UITableView *)tableView
                                            init:(void ( ^ )(__kindof UITableViewHeaderFooterView *view))initBlock;

+ (void)registerHeaderFooterWithTableView:(UITableView *)tableView;
+ (void)registerHeaderFooterWithTableView:(UITableView *)tableView usingNib:(UINib *)nib;

@end
