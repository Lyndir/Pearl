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
//  UIButton(PearlSelect)
//
//  Created by Maarten Billemont on 03/06/12.
//  Copyright 2012 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl(PearlSelect)

- (BOOL)selectionInSuperviewCandidate;
- (BOOL)selectionInSuperviewClearable;
- (void)setSelectionInSuperviewCandidate:(BOOL)providesSelection isClearable:(BOOL)clearable;

- (void)onHighlight:(void (^)(BOOL highlighted))aBlock;
- (void)onHighlight:(void (^)(BOOL highlighted))aBlock options:(NSKeyValueObservingOptions)options;
- (void)onSelect:(void (^)(BOOL selected))aBlock;
- (void)onSelect:(void (^)(BOOL selected))aBlock options:(NSKeyValueObservingOptions)options;
- (void)onHighlightOrSelect:(void (^)(BOOL highlighted, BOOL selected))aBlock;
- (void)onHighlightOrSelect:(void (^)(BOOL highlighted, BOOL selected))aBlock options:(NSKeyValueObservingOptions)options;

@end
