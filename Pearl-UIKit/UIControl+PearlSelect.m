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

#import "UIControl+PearlSelect.h"
#import "UIControl+PearlBlocks.h"

@implementation UIControl(PearlSelect)

static char selectionInSuperviewCandidateKey, selectionInSuperviewClearableKey;

- (NSMutableSet *)Pearl_controlsForSuperview {

    static NSMutableDictionary *superviewsControls = nil;
    if (!superviewsControls)
        superviewsControls = [NSMutableDictionary dictionary];

    NSValue *key = [NSValue valueWithNonretainedObject:self.superview];
    NSMutableSet *superviewControls = superviewsControls[key];
    if (!superviewControls)
        superviewsControls[key] = superviewControls = [NSMutableSet set];

    return superviewControls;
}

- (BOOL)selectionInSuperviewCandidate {

    return [objc_getAssociatedObject( self, &selectionInSuperviewCandidateKey ) boolValue];
}

- (BOOL)selectionInSuperviewClearable {

    return [objc_getAssociatedObject( self, &selectionInSuperviewClearableKey ) boolValue];
}

- (void)setSelectionInSuperviewCandidate:(BOOL)providesSelection isClearable:(BOOL)clearable {

    if (providesSelection) {
        if (self.superview)
            [[self Pearl_controlsForSuperview] addObject:[NSValue valueWithNonretainedObject:self]];
    }
    else
        [[self Pearl_controlsForSuperview] removeObject:[NSValue valueWithNonretainedObject:self]];

    if (!objc_getAssociatedObject( self, &selectionInSuperviewCandidateKey ))
        [self addActionForControlEvents:UIControlEventTouchUpInside action:^(id sender, UIEvent *event) {
            UIControl *const senderControl = (UIControl *)sender;
            if (!senderControl.selectionInSuperviewCandidate)
                return;

            if (senderControl.selected) {
                // Already selected, clear selection if clearable
                if (senderControl.selectionInSuperviewClearable)
                    senderControl.selected = NO;
            }
            else {
                for (NSValue *controlValue in [senderControl Pearl_controlsForSuperview]) {
                    UIControl *siblingControl = [controlValue nonretainedObjectValue];
                    if (siblingControl.superview != senderControl.superview)
                        // This siblingControl no longer exists in the superview.
                        continue;

                    if (siblingControl.selected)
                        siblingControl.selected = NO;
                }
                senderControl.selected = YES;
            }
        }];

    objc_setAssociatedObject( self, &selectionInSuperviewCandidateKey, @(providesSelection),
            OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    objc_setAssociatedObject( self, &selectionInSuperviewClearableKey, @(clearable),
            OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (void)onHighlight:(void (^)(BOOL highlighted))aBlock {

    [self onHighlight:aBlock options:NSKeyValueObservingOptionInitial];
}

- (void)onHighlight:(void (^)(BOOL highlighted))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *)object;

        block( senderControl.highlighted );
    }           forKeyPath:@"highlighted" options:options context:nil];
}

- (void)onSelect:(void (^)(BOOL selected))aBlock {

    [self onSelect:aBlock options:NSKeyValueObservingOptionInitial];
}

- (void)onSelect:(void (^)(BOOL selected))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *)object;

        block( senderControl.selected );
    }           forKeyPath:@"selected" options:options context:nil];
}

- (void)onHighlightOrSelect:(void (^)(BOOL highlighted, BOOL selected))aBlock {

    [self onHighlightOrSelect:aBlock options:NSKeyValueObservingOptionInitial];
}

- (void)onHighlightOrSelect:(void (^)(BOOL highlighted, BOOL selected))aBlock options:(NSKeyValueObservingOptions)options {

    void (^block)(BOOL, BOOL) = [aBlock copy];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *)object;

        block( senderControl.highlighted, senderControl.selected );
    }           forKeyPath:@"highlighted" options:options context:nil];
    [self addObserverBlock:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
        UIControl *const senderControl = (UIControl *)object;

        block( senderControl.highlighted, senderControl.selected );
    }           forKeyPath:@"selected" options:options context:nil];
}

@end
