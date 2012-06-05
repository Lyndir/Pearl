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
static char togglesSelectionInSuperview;

- (NSMutableSet *)Pearl_controlsForSuperview {

    static NSMutableDictionary *superviewsControls = nil;
    if (!superviewsControls)
        superviewsControls = [NSMutableDictionary dictionary];

    NSValue *key = [NSValue valueWithNonretainedObject:self.superview];
    NSMutableSet *superviewControls = [superviewsControls objectForKey:key];
    if (!superviewControls)
        [superviewsControls setObject:superviewControls = [NSMutableSet set] forKey:key];

    return superviewControls;
}

- (BOOL)togglesSelectionInSuperview {

    return [objc_getAssociatedObject(self, &togglesSelectionInSuperview) boolValue];
}

- (void)setTogglesSelectionInSuperview:(BOOL)toggle {

    if (toggle) {
        if (self.superview)
            [[self Pearl_controlsForSuperview] addObject:[NSValue valueWithNonretainedObject:self]];
    } else
        [[self Pearl_controlsForSuperview] removeObject:[NSValue valueWithNonretainedObject:self]];

    objc_setAssociatedObject(self, &togglesSelectionInSuperview, [NSNumber numberWithBool:toggle], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self addTargetBlock:^(id sender, UIControlEvents event) {
        UIControl *const senderControl = (UIControl *) sender;

        if (!senderControl.selected)
            for (NSValue *controlValue in [sender Pearl_controlsForSuperview]) {
                UIControl *control = [controlValue nonretainedObjectValue];
                if (![senderControl.superview.subviews containsObject:control])
                    // This control no longer exists in the superview.
                    continue;

                control.selected = NO;
            }

        senderControl.selected = !senderControl.selected;
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)onHighlightOrSelect:(void (^)(BOOL highlighted, BOOL selected))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL, BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *) object;

        block(senderControl.highlighted, senderControl.selected);
    } forKeyPath:@"highlighted" options:options context:nil];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *) object;

        block(senderControl.highlighted, senderControl.selected);
    } forKeyPath:@"selected" options:options context:nil];
}

- (void)onHighlight:(void (^)(BOOL highlighted))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *) object;

        block(senderControl.highlighted);
    } forKeyPath:@"highlighted" options:options context:nil];
}

- (void)onSelect:(void (^)(BOOL selected))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *) object;

        block(senderControl.selected);
    } forKeyPath:@"selected" options:options context:nil];
}

@end
