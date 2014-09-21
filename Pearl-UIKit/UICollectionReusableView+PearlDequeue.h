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

@interface UICollectionReusableView(PearlDequeue)

+ (instancetype)templateCellFromCollectionView:(UICollectionView *)collectionView;
+ (instancetype)templateSupplementaryFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;

+ (instancetype)dequeueCellFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
+ (instancetype)dequeueSupplementaryFromCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind
                                             indexPath:(NSIndexPath *)indexPath;

+ (void)registerCellWithCollectionView:(UICollectionView *)collectionView;
+ (void)registerCellWithCollectionView:(UICollectionView *)collectionView usingNib:(UINib *)nib;

+ (void)registerSupplementaryWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;
+ (void)registerSupplementaryWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind usingNib:(UINib *)nib;

+ (void)registerDecorationWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind;
+ (void)registerDecorationWithCollectionView:(UICollectionView *)collectionView kind:(NSString *)kind usingNib:(UINib *)nib;

@end
