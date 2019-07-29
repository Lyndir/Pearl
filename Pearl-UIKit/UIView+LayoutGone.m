//
// Created by Maarten Billemont on 2014-07-15.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+LayoutGone.h"

@interface UIView(LayoutGone_Private)

@property(nonatomic) NSArray /* <UIView> */ *goneParents;
@property(nonatomic, readonly) NSMutableSet /* <UIView> */ *goneChildren;
@property(nonatomic) BOOL gone;
@property(nonatomic) NSArray /* <NSLayoutConstraint> */ *goneConstraints;
@property(nonatomic) UIView *goneSuperview;
//@property(nonatomic) CGFloat *goneAlpha;
//@property(nonatomic) NSArray *goneTemporaryConstraints;

@end

@implementation UIView(LayoutGone)

- (NSArray *)goneParents {

    NSArray *goneParentRefs = [self getAssociatedObjectForSelector:@selector( goneParents ) ];
    NSMutableArray *goneParents = [NSMutableArray arrayWithCapacity:goneParentRefs.count];
    for (PearlWeakReference *goneParentRef in goneParentRefs) {
        NSLayoutConstraint *goneConstraint = goneParentRef.object;
        if (goneConstraint)
            [goneParents addObject:goneConstraint];

        else
            err( @"A gone parent was lost for view: %@\n"
                @"Make sure they remain strongly referenced while gone.", self );
    }

    return goneParents;
}

- (void)setGoneParents:(NSArray *)newGoneParents {

    // Remove ourselves as children from former parents.
    NSArray *oldGoneParentRefs = [self getAssociatedObjectForSelector:@selector( goneParents )];
    for (PearlWeakReference *oldGoneParentRef in oldGoneParentRefs) {
        UIView *object = oldGoneParentRef.object;
        if (![newGoneParents containsObject:PearlNotNull(object)])
            [object.goneChildren removeObject:self];
    }

    // Add ourselves as children to new parents.
    NSMutableArray *newGoneParentRefs = [NSMutableArray arrayWithCapacity:newGoneParents.count];
    for (UIView *newGoneParent in newGoneParents) {
        [newGoneParent.goneChildren addObject:self];
        [newGoneParentRefs addObject:[PearlWeakReference referenceWithObject:newGoneParent]];
    }

    [self setStrongAssociatedObject:newGoneParentRefs forSelector:@selector( goneParents )];
}

- (NSMutableSet *)goneChildren {

    // Get our children or make a new set if we don't have any yet.
    NSMutableSet *children = [self getAssociatedObjectForSelector:@selector( goneChildren ) ];
    if (!children)
        [self setStrongAssociatedObject:children = [NSMutableSet set] forSelector:@selector( goneChildren )];

    return children;
}

- (BOOL)gone {

    return [[self getAssociatedObjectForSelector:@selector( gone ) ] boolValue];
}

- (void)setGone:(BOOL)gone {

    if (gone == self.gone)
        return;

    [self setStrongAssociatedObject:@(gone) forSelector:@selector( gone )];

    [self updateGone];
}

- (NSArray *)goneConstraints {

    return [self getAssociatedObjectForSelector:@selector( goneConstraints )];
}

- (void)setGoneConstraints:(NSArray *)goneConstraints {

    [self setStrongAssociatedObject:goneConstraints forSelector:@selector( goneConstraints )];
}

- (UIView *)goneSuperview {

    return [self getAssociatedObjectForSelector:@selector( goneSuperview ) ];
}

- (void)setGoneSuperview:(UIView *)goneSuperview {

    [self setWeakAssociatedObject:goneSuperview forSelector:@selector( goneSuperview )];
}

- (BOOL)effectiveGone {

    // We are gone.
    if (self.gone)
        return YES;

    NSArray *goneParents = self.goneParents;
    if (![goneParents count])
        // We have no gone parents.
        return NO;

    for (UIView *goneParent in goneParents)
        if (!goneParent.effectiveGone)
            // One of our parents is visible.
            return NO;

    // All our parents are gone.
    return YES;
}

- (void)updateGone {

    BOOL wasGone = self.goneSuperview != nil, makeGone = self.effectiveGone;

    // If we just became visible, we need to add all our dependant children to the hierarchy before we start reinstalling constraints.
    if (!makeGone)
        [self restoreGoneSuperview];

    if (makeGone && !wasGone) {
//        [self.window?: self.superview?: self layoutIfNeeded];

        // Save and remove our constraints.
        self.goneConstraints = [self applicableConstraints];
//        [constraints makeObjectsPerformSelector:@selector( removeFromHolder )];

        // Lock our position with temporary constraints and fade out.
//        [self setStrongAssociatedObject:@(self.alpha) forSelector:&GoneAlpha];
//        NSArray *temporaryConstraints = [self.superview addConstraintsWithVisualFormats:@[ @"H:|-(x)-[view(w)]", @"V:|-(y)-[view(h)]" ]
//                                                                                options:0 metrics:@{
//                @"x" : @(self.frame.origin.x), @"y" : @(self.frame.origin.y),
//                @"w" : @(self.frame.size.width), @"h" : @(self.frame.size.height)
//            }                                                                     views:@{ @"view" : self }];
//        [self setStrongAssociatedObject:temporaryConstraints forSelector:&GoneTemporaryConstraints];

        // Inherit any existing animation, fade out in it and only after its completion remove ourselves from the hierarchy.
//        [UIView animateWithDuration:0 animations:^{
//            self.alpha = 0;
//        } completion:^(BOOL finished) {
//            if (finished && self.gone) {
                self.goneSuperview = self.superview;
                [self removeFromSuperview];
//            }
//        }];
    }

    if (!makeGone && wasGone) {
        // Remove our temporary constraints.
//        NSArray *temporaryConstraints = [self getAssociatedObjectForSelector:&GoneTemporaryConstraints];
//        [temporaryConstraints makeObjectsPerformSelector:@selector( removeFromHolder )];
//        [self setStrongAssociatedObject:nil forSelector:&GoneTemporaryConstraints];

        // Restore our saved constraints and fade back in.
        for (NSLayoutConstraint *constraint in self.goneConstraints) {
            BOOL restored = NO;
            // Find constraint holder for constraint: first common container for both items.
            for (UIView *constraintHolder = self; constraintHolder; constraintHolder = [constraintHolder superview])
                if ((!constraint.firstItem || [constraint.firstItem isDescendantOfView:constraintHolder]) &&
                    (!constraint.secondItem || [constraint.secondItem isDescendantOfView:constraintHolder])) {
                    [constraintHolder addConstraint:constraint];
                    restored = YES;
                    break;
                }

            if (!restored)
                err( @"Unable to restore constraint: %@\n"
                    @"Its item(s) are not yet in the hierarchy.  Make sure you don't have a gone dependency cycle.", constraint );
        }
//        self.alpha = [[self getAssociatedObjectForSelector:&GoneAlpha] floatValue];
//        [self setStrongAssociatedObject:nil forSelector:&GoneAlpha];
        self.goneConstraints = nil;
        self.goneSuperview = nil;
    }

    // Update the children who depend on us.
    for (UIView *goneChild in self.goneChildren)
        [goneChild updateGone];
}

- (void)restoreGoneSuperview {

    if (!self.superview) {
        // Add ourselves back to the hierarchy.
        [self.goneSuperview addSubview:self];
    }

    // Update the children who depend on us.
    for (UIView *goneChild in self.goneChildren)
        if (!goneChild.effectiveGone)
            [goneChild restoreGoneSuperview];
}

@end
