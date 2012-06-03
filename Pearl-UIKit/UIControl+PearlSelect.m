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

#import <objc/runtime.h>
#import "UIControl+PearlSelect.h"


@implementation UIControl (PearlSelect)
static char toggleSelectionWhenTouchedInsideKey;

- (BOOL)toggleSelectionWhenTouchedInside {

    return [objc_getAssociatedObject(self, &toggleSelectionWhenTouchedInsideKey) boolValue];
}

- (void)setToggleSelectionWhenTouchedInside:(BOOL)toggle {

    objc_setAssociatedObject(self, &toggleSelectionWhenTouchedInsideKey, [NSNumber numberWithBool:toggle], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self addTargetBlock:^(id sender, UIControlEvents event) {
        self.selected = !self.selected;
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)onHighlightOrSelect:(void (^)(BOOL highlighted, BOOL selected))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL, BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        block(self.highlighted, self.selected);
    } forKeyPath:@"highlighted" options:options context:nil];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        block(self.highlighted, self.selected);
    } forKeyPath:@"selected" options:options context:nil];
}

- (void)onHighlight:(void (^)(BOOL highlighted))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        block(self.highlighted);
    } forKeyPath:@"highlighted" options:options context:nil];
}

- (void)onSelect:(void (^)(BOOL selected))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        block(self.selected);
    } forKeyPath:@"selected" options:options context:nil];
}

@end
