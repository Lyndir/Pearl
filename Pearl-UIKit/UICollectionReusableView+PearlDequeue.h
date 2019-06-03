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
//  UICollectionReusableView(PearlDequeue)
//
//  Created by Maarten Billemont on 2014-05-26.
//  Copyright 2014 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionReusableView(PearlDequeue)

+ (instancetype)templateFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;

+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                indexPath:(NSIndexPath *)indexPath
                                     init:(void ( ^ )(__kindof UICollectionReusableView *cell))initBlock;

@end

@interface UICollectionViewCell(PearlDequeue)

+ (instancetype)templateFromCollectionView:(UICollectionView *)collectionView;

+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
                                     init:(void ( ^ )(__kindof UICollectionViewCell *cell))initBlock;

@end

@interface UICollectionView(PearlDequeue)

- (void)registerSupplementaryView:(Class/* UICollectionReusableView */)supplementaryView kind:(NSString *)kind;
- (void)registerSupplementaryView:(Class/* UICollectionReusableView */)supplementaryView kind:(NSString *)kind usingNib:(UINib *)nib;

- (void)registerDecorationView:(Class/* UICollectionReusableView */)decorationView kind:(NSString *)kind;
- (void)registerDecorationView:(Class/* UICollectionReusableView */)decorationView kind:(NSString *)kind usingNib:(UINib *)nib;

- (void)registerCell:(Class/* UICollectionViewCell */)cell;
- (void)registerCell:(Class/* UICollectionViewCell */)cell usingNib:(UINib *)nib;

@end

NS_ASSUME_NONNULL_END
