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

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell(PearlDeque)

+ (instancetype)templateFromTableView:(UITableView *)tableView;

+ (instancetype)dequeueFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueFromTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
                                init:(void ( ^ )(__kindof UITableViewCell *cell))initBlock;

@end

@interface UITableViewHeaderFooterView(PearlDeque)

+ (instancetype)dequeueFromTableView:(UITableView *)tableView;
+ (instancetype)dequeueFromTableView:(UITableView *)tableView
                                init:(void ( ^ )(__kindof UITableViewHeaderFooterView *view))initBlock;

@end

@interface UITableView(PearlDeque)

- (void)registerNibCell:(Class/* UITableViewCell */)cell;
- (void)registerCell:(Class/* UITableViewCell */)cell;
- (void)registerCell:(Class/* UITableViewCell */)cell usingNib:(UINib *)nib;

- (void)registerHeaderFooter:(Class/* UITableViewHeaderFooterView */)headerFooterView;
- (void)registerHeaderFooter:(Class/* UITableViewHeaderFooterView */)headerFooterView usingNib:(UINib *)nib;

@end

NS_ASSUME_NONNULL_END
