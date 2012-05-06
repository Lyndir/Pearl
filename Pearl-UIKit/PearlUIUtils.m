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
//  PearlUIUtils.m
//  Pearl
//
//  Created by Maarten Billemont on 29/10/10.
//  Copyright 2010, lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlUIUtils.h"
#import "PearlLogger.h"
#import "PearlAppDelegate.h"
#import "PearlBoxView.h"
#import "PearlObjectUtils.h"
#import "PearlStringUtils.h"


CGRect CGRectSetX(CGRect rect, CGFloat x) {
    
    return (CGRect){{x, rect.origin.y}, {rect.size.width, rect.size.height}};
}
CGRect CGRectSetY(CGRect rect, CGFloat y) {
    
    return (CGRect){{rect.origin.x, y}, {rect.size.width, rect.size.height}};
}
CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
    
    return (CGRect){rect.origin, {width, rect.size.height}};
}
CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
    
    return (CGRect){rect.origin, {rect.size.width, height}};
}
CGPoint CGPointFromCGRectCenter(CGRect rect) {
    
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}
CGPoint CGPointFromCGRectTop(CGRect rect) {
    
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y);
}
CGPoint CGPointFromCGRectRight(CGRect rect) {
    
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2);
}
CGPoint CGPointFromCGRectBottom(CGRect rect) {
    
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height);
}
CGPoint CGPointFromCGRectLeft(CGRect rect) {
    
    return CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
}
CGPoint CGPointFromCGRectTopLeft(CGRect rect) {
    
    return CGPointMake(rect.origin.x, rect.origin.y);
}
CGPoint CGPointFromCGRectTopRight(CGRect rect) {
    
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
}
CGPoint CGPointFromCGRectBottomRight(CGRect rect) {
    
    return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}
CGPoint CGPointFromCGRectBottomLeft(CGRect rect) {
    
    return CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
}
CGPoint CGPointFromCGSize(const CGSize size) {
    
    return CGPointMake(size.width, size.height);
}
CGPoint CGPointFromCGSizeCenter(const CGSize size) {
    
    return CGPointMake(size.width / 2, size.height / 2);
}
CGSize CGSizeFromCGPoint(const CGPoint point) {
    
    return CGSizeMake(point.x, point.y);
}
CGRect CGRectFromCGPointAndCGSize(const CGPoint point, const CGSize size) {
    
    return CGRectMake(point.x, point.y, size.width, size.height);
}

@implementation UIView (PearlUIUtils)

- (void)iterateSubviewsContinueAfter:(BOOL (^)(UIView *))continueAfter {
    
    for (UIView *subview in self.subviews)
        if (continueAfter(subview))
            [subview iterateSubviewsContinueAfter:continueAfter];
}

@end

@implementation UIImage (PearlUIUtils)

- (UIImage *)highlightedImage {
    
    const CGRect    bounds = CGRectFromCGPointAndCGSize(CGPointZero, self.size);
    UIColor         *color = [[UIColor alloc] initWithWhite:1 alpha:0.7f];
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, FALSE, 0);
    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    // transform CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    // draw original image
    CGContextDrawImage(context, bounds, self.CGImage);
    
    // draw highlight overlay
    CGContextClipToMask(context, bounds, self.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bounds);
    
    // finish image context
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end

@interface PearlUIUtils ()

+ (void)keyboardWillHide:(NSNotification *)n;
+ (void)keyboardWillShow:(NSNotification *)n;

@end


@implementation PearlUIUtils

static UIScrollView     *keyboardScrollView_current, *keyboardScrollView_resized;
static CGPoint          keyboardScrollView_originalOffset;
static CGRect           keyboardScrollView_originalFrame;
static BOOL             keyboardScrollView_shouldHide;
static NSMutableSet     *dismissableResponders;

+ (void)autoSize:(UILabel *)label {
    
    label.frame = CGRectSetHeight(label.frame, [label textRectForBounds:CGRectSetHeight(label.frame, CGFLOAT_MAX)
                                                 limitedToNumberOfLines:label.numberOfLines].size.height);
}

+ (void)autoSizeContent:(UIScrollView *)scrollView {
    
    [self autoSizeContent:scrollView ignoreSubviews:nil];
}

+ (void)autoSizeContent:(UIScrollView *)scrollView ignoreSubviews:(UIView *)ignoredSubviews, ... {
    
    NSMutableArray *ignoredSubviewsArray = [NSMutableArray array];
    va_into(ignoredSubviewsArray, ignoredSubviews);
    
    [self autoSizeContent:scrollView ignoreSubviewsArray:ignoredSubviewsArray];
}

+ (void)autoSizeContent:(UIScrollView *)scrollView ignoreSubviewsArray:(NSArray *)ignoredSubviewsArray {
    
    // === Step 1: Calculate the UIScrollView's contentSize.
    // Determine content frame.
    CGRect contentRect = CGRectNull;
    for (UIView *subview in scrollView.subviews)
        if (!subview.hidden && subview.alpha && ![ignoredSubviewsArray containsObject:subview]) {
            CGRect subviewContent = [self contentBoundsFor:subview ignoreSubviewsArray:ignoredSubviewsArray];
            subviewContent = [scrollView convertRect:subviewContent fromView:subview];
            
            if (CGRectIsNull(contentRect))
                contentRect = subviewContent;
            else
                contentRect = CGRectUnion(contentRect, subviewContent);
        }
    if (CGRectEqualToRect(contentRect, CGRectNull))
        // No subviews inside the scroll area.
        contentRect = CGRectZero;
    
    // Add right/bottom padding by adding left/top offset to the size (but no more than 20px).
    CGSize originPadding = CGSizeMake(fmaxf(0, contentRect.origin.x), fmaxf(0, contentRect.origin.y));
    CGRect paddedRect = (CGRect){CGPointZero,
        CGSizeMake(contentRect.size.width   + originPadding.width + fminf(originPadding.width, 20),
                   contentRect.size.height  + originPadding.height + fminf(originPadding.height, 20))};
    
    // Apply rect to scrollView's content definition.
    scrollView.contentOffset = CGPointZero;
    scrollView.contentSize = paddedRect.size;
    
    // === Step 2: Manage the scroll view on keyboard notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:scrollView.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:scrollView.window];
    keyboardScrollView_current = scrollView;
}

+ (CGRect)contentBoundsFor:(UIView *)view ignoreSubviews:(UIView *)ignoredSubviews, ... {
    
    NSMutableArray *ignoredSubviewsArray = [NSMutableArray array];
    va_into(ignoredSubviewsArray, ignoredSubviews);
    
    return [self contentBoundsFor:view ignoreSubviewsArray:ignoredSubviewsArray];
}

+ (CGRect)contentBoundsFor:(UIView *)view ignoreSubviewsArray:(NSArray *)ignoredSubviewsArray {
    
    CGRect contentRect = view.bounds;
    if (!view.clipsToBounds)
        for (UIView *subview in view.subviews)
            if (!subview.hidden && subview.alpha && ![ignoredSubviewsArray containsObject:subview])
                contentRect = CGRectUnion(contentRect,
                                          [view convertRect:
                                           [self contentBoundsFor:subview ignoreSubviewsArray:ignoredSubviewsArray]
                                                   fromView:subview]);
    
    return contentRect;
}

+ (void)showBoundingBoxForView:(UIView *)view {
    
    [self showBoundingBoxForView:view color:[UIColor redColor]];
}

+ (void)showBoundingBoxForView:(UIView *)view color:(UIColor *)color {
    
    dbg(@"Showing bounding box for view: %@", view);
    PearlBoxView *box = [PearlBoxView boxWithFrame:(CGRect){CGPointZero, view.bounds.size} color:color];
    [view addSubview:box];
    [view addObserver:box forKeyPath:@"bounds" options:0 context:nil];
}

+ (CGRect)frameInWindow:(UIView *)view {
    
    return [view.window convertRect:view.bounds fromView:view];
}

+ (UIView *)findFirstResonder {
    
    return [self findFirstResonderIn:[UIApplication sharedApplication].keyWindow];
}

+ (CGRect)frameForItem:(UITabBarItem *)item inTabBar:(UITabBar *)tabBar {
    
    CGFloat tabItemWidth = tabBar.frame.size.width / tabBar.items.count;
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex == NSNotFound)
        return CGRectNull;
    
    return CGRectMake(tabIndex * tabItemWidth, 0, tabItemWidth, tabBar.bounds.size.height);
}

+ (UIView *)findFirstResonderIn:(UIView *)view {
    
    if (view.isFirstResponder)
        return view;
    
    for (UIView *subView in view.subviews) {
        UIView *firstResponder = [self findFirstResonderIn:subView];
        if (firstResponder != nil)
            return firstResponder;
    }
    
    return nil;
}

+ (void)makeDismissable:(UIView *)views, ... {
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    va_into(viewsArray, views);
    
    [self makeDismissableArray:viewsArray];
}

+ (void)makeDismissableArray:(NSArray *)viewsArray {
    
    if (!dismissableResponders)
        dismissableResponders = [[NSMutableSet alloc] initWithCapacity:3];
    
    [dismissableResponders addObjectsFromArray:viewsArray];
}

+ (void)keyboardWillShow:(NSNotification *)n {
    
    UIView *responder = [self findFirstResonder];
    if (!responder)
        // Sometimes we seem to get these notifications even though there's no responder, and no keyboard shows up.
        // Don't know why but since no keyboard actually appears in this case, ignore them.
        return;
    
    // Make sure no old view is still resized and a current view is set.
    if (keyboardScrollView_resized || !keyboardScrollView_current) {
        if (keyboardScrollView_resized && keyboardScrollView_resized != keyboardScrollView_current)
            err(@"Keyboard shown for a scroll view while another scroll view is still resized.  We missed a keyboardWillHide: for keyboardScrollView_resized!");
        else
            keyboardScrollView_shouldHide = NO;
        
        return;
    }
    assert(keyboardScrollView_current);
    assert(!keyboardScrollView_resized);
    
    // Activate scrollview so we know which one to restore when the keyboard is hidden.
    keyboardScrollView_resized = keyboardScrollView_current;
    
    NSDictionary* userInfo = [n userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect scrollRect   = [self frameInWindow:keyboardScrollView_resized];
    CGRect hiddenRect   = CGRectIntersection(scrollRect, keyboardRect);
    
    keyboardScrollView_originalOffset       = keyboardScrollView_resized.contentOffset;
    keyboardScrollView_originalFrame        = keyboardScrollView_resized.frame;
    CGPoint keyboardScrollNewOffset         = keyboardScrollView_originalOffset;
    keyboardScrollNewOffset.y               += keyboardRect.size.height / 2;
    CGRect keyboardScrollNewFrame           = keyboardScrollView_resized.frame;
    keyboardScrollNewFrame.size.height      -= hiddenRect.size.height;
    
    CGRect responderRect = [keyboardScrollView_resized convertRect:responder.bounds fromView:responder];
    
    if (responderRect.origin.y < keyboardScrollNewOffset.y)
        keyboardScrollNewOffset.y = 0;
    else if (responderRect.origin.y > keyboardScrollNewOffset.y + keyboardScrollNewFrame.size.height)
        keyboardScrollNewOffset.y = responderRect.origin.y;
    
    UIScrollView *animatingScrollView = keyboardScrollView_resized;
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0 options:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue]
                     animations:^{
                         animatingScrollView.contentOffset  = keyboardScrollNewOffset;
                     } completion:^(BOOL finished){
                         animatingScrollView.frame          = keyboardScrollNewFrame;
                     }];
}

+ (void)keyboardWillHide:(NSNotification *)n {
    
    if (!keyboardScrollView_resized)
        // Don't do any scrollview animation when no scrollview is active.
        return;
    
    UIScrollView *animatingScrollView           = keyboardScrollView_resized;
    CGRect animatingScrollView_originalFrame    = keyboardScrollView_originalFrame;
    CGPoint animatingScrollView_originalOffset  = keyboardScrollView_originalOffset;
    keyboardScrollView_shouldHide               = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!keyboardScrollView_shouldHide)
            return;
        
        CGPoint currentOffset                   = animatingScrollView.contentOffset;
        animatingScrollView.frame               = animatingScrollView_originalFrame;
        animatingScrollView.contentOffset       = currentOffset;
        
        [UIView animateWithDuration:[[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0 options:[[n.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue]
                         animations:^{
                             animatingScrollView.contentOffset = animatingScrollView_originalOffset;
                         } completion:^(BOOL finished) {
                         }];
        
        keyboardScrollView_resized = nil;
    });
}

+ (id)copyOf:(id)view {
    
    return [self copyOf:view addTo:[view superview]];
}

+ (id)copyOf:(id)view addTo:(UIView *)superView {
    
    id copy = [[[view class] alloc] initWithFrame:[view frame]];
    
    NSMutableArray *properties = [NSMutableArray array];
    
    // UIView
    if ([view isKindOfClass:[UIView class]]) {
        [properties addObject:@"userInteractionEnabled"];
        [properties addObject:@"tag"];
        [properties addObject:@"bounds"];
        [properties addObject:@"center"];
        [properties addObject:@"transform"];
        [properties addObject:@"contentScaleFactor"];
        [properties addObject:@"multipleTouchEnabled"];
        [properties addObject:@"exclusiveTouch"];
        [properties addObject:@"autoresizesSubviews"];
        [properties addObject:@"autoresizingMask"];
        [properties addObject:@"clipsToBounds"];
        [properties addObject:@"backgroundColor"];
        [properties addObject:@"alpha"];
        [properties addObject:@"opaque"];
        [properties addObject:@"clearsContextBeforeDrawing"];
        [properties addObject:@"hidden"];
        [properties addObject:@"contentMode"];
        [properties addObject:@"contentStretch"];
    }
    
    // UILabel
    if ([view isKindOfClass:[UILabel class]]) {
        [properties addObject:@"text"];
        [properties addObject:@"font"];
        [properties addObject:@"textColor"];
        [properties addObject:@"shadowColor"];
        [properties addObject:@"shadowOffset"];
        [properties addObject:@"textAlignment"];
        [properties addObject:@"lineBreakMode"];
        [properties addObject:@"highlightedTextColor"];
        [properties addObject:@"highlighted"];
        [properties addObject:@"enabled"];
        [properties addObject:@"numberOfLines"];
        [properties addObject:@"adjustsFontSizeToFitWidth"];
        [properties addObject:@"minimumFontSize"];
        [properties addObject:@"baselineAdjustment"];
    }
    
    // UIControl
    if ([view isKindOfClass:[UIControl class]]) {
        [properties addObject:@"enabled"];
        [properties addObject:@"selected"];
        [properties addObject:@"highlighted"];
        [properties addObject:@"contentVerticalAlignment"];
        [properties addObject:@"contentHorizontalAlignment"];
        
        // Copy actions.
        for (id target in [view allTargets])
            if (target != [NSNull null])
                for (NSUInteger c = 0; c < 32; ++c)
                    for (NSString *action in [view actionsForTarget:target forControlEvent:1 << c])
                        [copy addTarget:target action:NSSelectorFromString(action) forControlEvents:1 << c];
    }
    
    // UITextField
    if ([view isKindOfClass:[UITextField class]]) {
        [properties addObject:@"text"];
        [properties addObject:@"textColor"];
        [properties addObject:@"font"];
        [properties addObject:@"textAlignment"];
        [properties addObject:@"borderStyle"];
        [properties addObject:@"placeholder"];
        [properties addObject:@"clearsOnBeginEditing"];
        [properties addObject:@"adjustsFontSizeToFitWidth"];
        [properties addObject:@"minimumFontSize"];
        [properties addObject:@"delegate"];
        [properties addObject:@"background"];
        [properties addObject:@"disabledBackground"];
        [properties addObject:@"clearButtonMode"];
        [view setLeftView:[self copyOf:[view leftView]]];
        [properties addObject:@"leftViewMode"];
        [view setRightView:[self copyOf:[view rightView]]];
        [properties addObject:@"rightViewMode"];
        [view setInputView:[self copyOf:[view inputView]]];
        [view setInputAccessoryView:[self copyOf:[view inputAccessoryView]]];
    }
    
    // UIButton
    if ([view isKindOfClass:[UIButton class]]) {
        [properties addObject:@"contentEdgeInsets"];
        [properties addObject:@"titleEdgeInsets"];
        [properties addObject:@"reversesTitleShadowWhenHighlighted"];
        [properties addObject:@"imageEdgeInsets"];
        [properties addObject:@"adjustsImageWhenHighlighted"];
        [properties addObject:@"adjustsImageWhenDisabled"];
        [properties addObject:@"showsTouchWhenHighlighted"];
        // TODO: Copy all properties from titleLabel, imageView.
    }
    
    // UIImageView
    if ([view isKindOfClass:[UIImageView class]]) {
        [properties addObject:@"image"];
        [properties addObject:@"highlightedImage"];
        [properties addObject:@"userInteractionEnabled"];
        [properties addObject:@"highlighted"];
        [properties addObject:@"animationImages"];
        [properties addObject:@"highlightedAnimationImages"];
        [properties addObject:@"animationDuration"];
        [properties addObject:@"animationRepeatCount"];
    }
    
    // Copy properties.
    [copy setValuesForKeysWithDictionary:[view dictionaryWithValuesForKeys:properties]];
    
    // Add copy to view's hierarchy and copy on recursively.
    [superView addSubview:copy];
    for (UIView *subView in [view subviews])
        [self copyOf:subView addTo:copy];
    
    return copy;
}

+ (void)loadLocalization:(UIView *)view {
    
    static NSArray *UIUtils_localizableProperties = nil;
    if (UIUtils_localizableProperties == nil)
        UIUtils_localizableProperties = [[NSArray alloc] initWithObjects:@"text", @"placeholder", nil];
    
    // Load localization for each of the view's supported properties.
    for (NSString *localizableProperty in UIUtils_localizableProperties) {
        if ([view respondsToSelector:NSSelectorFromString(localizableProperty)]) {
            id value = [view valueForKey:localizableProperty];
            if ([value isKindOfClass:[NSString class]])
                [view setValue:[self applyLocalization:value] forKey:localizableProperty];
        }
    }
    
    // Handle certain types of view specially.
    if ([view isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentView = (UISegmentedControl *)view;
        
        // Localize titles of segments.
        for (NSUInteger segment = 0; segment < [segmentView numberOfSegments]; ++segment)
            [segmentView setTitle:[self applyLocalization:[segmentView titleForSegmentAtIndex:segment]]
                forSegmentAtIndex:segment];
    }
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        
        // Localize titles of segments.
        UIControlState states[] = { UIControlStateNormal, UIControlStateHighlighted, UIControlStateDisabled, UIControlStateSelected, UIControlStateApplication };
        for (NSUInteger s = 0; s < 5; ++s) {
            UIControlState state = states[s];
            NSString *title = [button titleForState:state];
            if (title)
                [button setTitle:[self applyLocalization:title] forState:state];
        }
    }
    if ([view isKindOfClass:[UITabBar class]]) {
        UITabBar *tabBar = (UITabBar *)view;
        
        for (UITabBarItem *item in tabBar.items)
            item.title = [self applyLocalization:item.title];
    }
    
    // Load localization for all children, too.
    for (UIView *childView in [view subviews])
        [self loadLocalization:childView];
}

+ (NSString *)applyLocalization:(NSString *)localizableValue {
    
    static NSRegularExpression *UIUtils_localizableSyntax = nil;
    if (UIUtils_localizableSyntax == nil)
        UIUtils_localizableSyntax = [[NSRegularExpression alloc] initWithPattern:@"^\\{([^:]*)(?::(.*))?\\}$" options:0 error:nil];
    
    __block NSString *localizedValue = localizableValue;
    [UIUtils_localizableSyntax enumerateMatchesInString:localizableValue options:0 range:NSMakeRange(0, [localizableValue length]) usingBlock:
     ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
         if (result) {
             NSRange localizationKeyRange   = [result rangeAtIndex:1];
             NSRange defaultValueRange      = [result rangeAtIndex:2];
             if (NSEqualRanges(localizationKeyRange, NSMakeRange(NSNotFound , 0)))
                 return;
             
             NSString *localizationKey  = [localizableValue substringWithRange:localizationKeyRange];
             NSString *defaultValue     = nil;
             if (!NSEqualRanges(defaultValueRange, NSMakeRange(NSNotFound , 0)))
                 defaultValue           = [localizableValue substringWithRange:defaultValueRange];
             
             localizedValue = NSLocalizedStringWithDefaultValue(localizationKey, nil, [NSBundle mainBundle], defaultValue, nil);
         }
     }];
    
    return localizedValue;
}

@end
