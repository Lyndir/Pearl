//
// Created by Maarten Billemont on 2014-07-15.
// Copyright (c) 2014 Tristan Interactive. All rights reserved.
//

#import "UIView+LayoutGone.h"

@interface UIView(LayoutGone_Private)

@property(nonatomic) NSArray *goneParents;
@property(nonatomic, readonly) NSMutableSet *goneChildren;
@property(nonatomic) BOOL gone;
@property(nonatomic) NSArray *goneConstraints;
@property(nonatomic) UIView *goneSuperview;
//@property(nonatomic) CGFloat *goneAlpha;
//@property(nonatomic) NSArray *goneTemporaryConstraints;

@end

@implementation UIView(LayoutGone)

- (NSArray *)goneParents {

    return objc_getAssociatedObject( self, @selector( goneParents ) );
}

- (void)setGoneParents:(NSArray *)goneParents {

    // Remove ourselves as children from former parents.
    for (UIView *goneParent in self.goneParents)
        if (![goneParents containsObject:goneParent])
            [goneParent.goneChildren removeObject:self];

    // Add ourselves as children to new parents.
    for (UIView *goneParent in goneParents)
        [goneParent.goneChildren addObject:self];

    objc_setAssociatedObject( self, @selector( goneParents ), goneParents, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (NSMutableSet *)goneChildren {

    // Get our children or make a new set if we don't have any yet.
    NSMutableSet *children = objc_getAssociatedObject( self, @selector( goneChildren ) );
    if (!children)
        objc_setAssociatedObject( self, @selector( goneChildren ), children = [NSMutableSet set], OBJC_ASSOCIATION_RETAIN_NONATOMIC );

    return children;
}

- (BOOL)gone {

    return [objc_getAssociatedObject( self, @selector( gone ) ) boolValue];
}

- (void)setGone:(BOOL)gone {

    if (gone == self.gone)
        return;

    objc_setAssociatedObject( self, @selector( gone ), @(gone), OBJC_ASSOCIATION_RETAIN_NONATOMIC );

    [self updateGone];
}

- (NSArray *)goneConstraints {

    return objc_getAssociatedObject( self, @selector( goneConstraints ) );
}

- (void)setGoneConstraints:(NSArray *)goneConstraints {

    objc_setAssociatedObject( self, @selector( goneConstraints ), goneConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (UIView *)goneSuperview {

    return objc_getAssociatedObject( self, @selector( goneSuperview ) );
}

- (void)setGoneSuperview:(UIView *)goneSuperview {

    objc_setAssociatedObject( self, @selector( goneSuperview ), goneSuperview, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (BOOL)effectiveGone {

    // We are gone.
    if (self.gone)
        return YES;

    if ([self.goneParents count]) {
        for (UIView *goneParent in self.goneParents)
            if (!goneParent.effectiveGone)
                return NO;

        // All our parents are gone.
        return YES;
    }

    return NO;
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
//        objc_setAssociatedObject( self, &GoneAlpha, @(self.alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//        NSArray *temporaryConstraints = [self.superview addConstraintsWithVisualFormats:@[ @"H:|-(x)-[view(w)]", @"V:|-(y)-[view(h)]" ]
//                                                                                options:0 metrics:@{
//                @"x" : @(self.frame.origin.x), @"y" : @(self.frame.origin.y),
//                @"w" : @(self.frame.size.width), @"h" : @(self.frame.size.height)
//            }                                                                     views:@{ @"view" : self }];
//        objc_setAssociatedObject( self, &GoneTemporaryConstraints, temporaryConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC );

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
//        NSArray *temporaryConstraints = objc_getAssociatedObject( self, &GoneTemporaryConstraints );
//        [temporaryConstraints makeObjectsPerformSelector:@selector( removeFromHolder )];
//        objc_setAssociatedObject( self, &GoneTemporaryConstraints, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );

        // Restore our saved constraints and fade back in.
        for (NSLayoutConstraint *constraint in self.goneConstraints) {
            BOOL restored = NO;
            // Find constraint holder for constraint: first common container for both items.
            for (UIView *constraintHolder = constraint.firstItem; constraintHolder; constraintHolder = [constraintHolder superview])
                if (!constraint.secondItem || [constraint.secondItem isDescendantOfView:constraintHolder]) {
                    [constraintHolder addConstraint:constraint];
                    restored = YES;
                    break;
                }
            if (!restored)
                err( @"Constraint was lost since its items aren't yet in the hierarchy: %@\n"
                    @"Make sure you aren't explicitly making multiple dependent views gone.", constraint );
        }
//        self.alpha = [objc_getAssociatedObject( self, &GoneAlpha ) floatValue];
//        objc_setAssociatedObject( self, &GoneAlpha, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
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
