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

#import <objc/runtime.h>

CGRect CGRectSetX(CGRect rect, CGFloat x) {

    return (CGRect){ { x, rect.origin.y }, { rect.size.width, rect.size.height } };
}

CGRect CGRectSetY(CGRect rect, CGFloat y) {

    return (CGRect){ { rect.origin.x, y }, { rect.size.width, rect.size.height } };
}

CGRect CGRectSetWidth(CGRect rect, CGFloat width) {

    return (CGRect){ rect.origin, { width, rect.size.height } };
}

CGRect CGRectSetHeight(CGRect rect, CGFloat height) {

    return (CGRect){ rect.origin, { rect.size.width, height } };
}

CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {

    return (CGRect){ origin, rect.size };
}

CGRect CGRectSetSize(CGRect rect, CGSize size) {

    return (CGRect){ rect.origin, size };
}

CGPoint CGPointFromCGRectCenter(CGRect rect) {

    return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2 );
}

CGPoint CGPointFromCGRectTop(CGRect rect) {

    return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y );
}

CGPoint CGPointFromCGRectRight(CGRect rect) {

    return CGPointMake( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2 );
}

CGPoint CGPointFromCGRectBottom(CGRect rect) {

    return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height );
}

CGPoint CGPointFromCGRectLeft(CGRect rect) {

    return CGPointMake( rect.origin.x, rect.origin.y + rect.size.height / 2 );
}

CGPoint CGPointFromCGRectTopLeft(CGRect rect) {

    return CGPointMake( rect.origin.x, rect.origin.y );
}

CGPoint CGPointFromCGRectTopRight(CGRect rect) {

    return CGPointMake( rect.origin.x + rect.size.width, rect.origin.y );
}

CGPoint CGPointFromCGRectBottomRight(CGRect rect) {

    return CGPointMake( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height );
}

CGPoint CGPointFromCGRectBottomLeft(CGRect rect) {

    return CGPointMake( rect.origin.x, rect.origin.y + rect.size.height );
}

CGPoint CGPointFromCGSize(const CGSize size) {

    return CGPointMake( size.width, size.height );
}

CGPoint CGPointFromCGSizeCenter(const CGSize size) {

    return CGPointMake( size.width / 2, size.height / 2 );
}

CGSize CGSizeFromCGPoint(const CGPoint point) {

    return CGSizeMake( point.x, point.y );
}

CGRect CGRectFromOriginWithSize(const CGPoint origin, const CGSize size) {

    return CGRectMake( origin.x, origin.y, size.width, size.height );
}

CGRect CGRectFromCenterWithSize(const CGPoint center, const CGSize size) {

    return CGRectMake( center.x - size.width / 2, center.y - size.height / 2, size.width, size.height );
}

CGRect CGRectInCGRectWithSizeAndPadding(const CGRect parent, CGSize size, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {

    if (size.width == CGFLOAT_MAX) {
        if (left == CGFLOAT_MAX && right == CGFLOAT_MAX)
            left = right = size.width = parent.size.width / 3;
        else if (left == CGFLOAT_MAX)
            left = size.width = (parent.size.width - right) / 2;
        else if (right == CGFLOAT_MAX)
            right = size.width = (parent.size.width - left) / 2;
        else
            size.width = parent.size.width - left - right;
    }
    if (size.height == CGFLOAT_MAX) {
        if (top == CGFLOAT_MAX && bottom == CGFLOAT_MAX)
            top = bottom = size.height = parent.size.height / 3;
        else if (top == CGFLOAT_MAX)
            top = size.height = (parent.size.height - bottom) / 2;
        else if (bottom == CGFLOAT_MAX)
            bottom = size.height = (parent.size.height - top) / 2;
        else
            size.height = parent.size.height - top - bottom;
    }
    if (top == CGFLOAT_MAX) {
        if (bottom == CGFLOAT_MAX)
            top = (parent.size.height - size.height) / 2;
        else
            top = parent.size.height - size.height - bottom;
    }
    if (left == CGFLOAT_MAX) {
        if (right == CGFLOAT_MAX)
            left = (parent.size.width - size.width) / 2;
        else
            left = parent.size.width - size.width - right;
    }

    return CGRectFromOriginWithSize( CGPointMake( parent.origin.x + left, parent.origin.y + top ), size );
}

CGPoint CGPointMinusCGPoint(const CGPoint origin, const CGPoint subtract) {

    return CGPointMake( origin.x - subtract.x, origin.y - subtract.y );
}

CGPoint CGPointPlusCGPoint(const CGPoint origin, const CGPoint add) {

    return CGPointMake( origin.x + add.x, origin.y + add.y );
}

CGPoint CGPointMultiply(const CGPoint origin, const CGFloat multiply) {

    return CGPointMake( origin.x * multiply, origin.y * multiply );
}

CGPoint CGPointMultiplyCGPoint(const CGPoint origin, const CGPoint multiply) {

    return CGPointMake( origin.x * multiply.x, origin.y * multiply.y );
}

CGPoint CGPointDistanceBetweenCGPoints(CGPoint from, CGPoint to) {

    return CGPointMinusCGPoint( to, from );
}

CGFloat DistanceBetweenCGPointsSq(CGPoint from, CGPoint to) {

    return powf( to.x - from.x, 2 ) + powf( to.y - from.y, 2 );
}

CGFloat DistanceBetweenCGPoints(CGPoint from, CGPoint to) {

    return sqrtf( DistanceBetweenCGPointsSq( from, to ) );
}

@interface PearlUIUtilsKeyboardScrollView : NSObject

@property(nonatomic, retain) UIScrollView *keyboardScrollView;
@property(nonatomic) CGPoint keyboardScrollViewOriginalOffset;
@property(nonatomic) CGRect keyboardScrollViewOriginalFrame;

@end

@implementation PearlUIUtilsKeyboardScrollView

@synthesize keyboardScrollView = _keyboardScrollView;
@synthesize keyboardScrollViewOriginalOffset = _keyboardScrollViewOriginalOffset;
@synthesize keyboardScrollViewOriginalFrame = _keyboardScrollViewOriginalFrame;

- (id)init {

    if (!(self = [super init])) {
        return nil;
    }

    self.keyboardScrollViewOriginalFrame = CGRectNull;
    self.keyboardScrollViewOriginalOffset = CGPointZero;

    return self;
}

@end

// TODO: dont hold strong references to the scrollviews
static NSMutableArray *keyboardScrollViews;
static UIScrollView *keyboardScrollView_resized;
static BOOL keyboardScrollView_shouldHide;

static NSMutableSet *dismissableResponders;

@interface PearlUIUtils()

+ (void)keyboardWillHide:(NSNotification *)n;
+ (void)keyboardWillShow:(NSNotification *)n;

@end

@implementation UIImage(PearlUIUtils)

- (UIImage *)highlightedImage {

    const CGRect bounds = CGRectFromOriginWithSize( CGPointZero, self.size );
    UIColor *color = [[UIColor alloc] initWithWhite:1 alpha:0.7f];

    UIGraphicsBeginImageContextWithOptions( bounds.size, FALSE, 0 );
    CGContextRef context = UIGraphicsGetCurrentContext();

    // transform CG* coords to UI* coords
    CGContextTranslateCTM( context, 0, bounds.size.height );
    CGContextScaleCTM( context, 1, -1 );

    // draw original image
    CGContextDrawImage( context, bounds, self.CGImage );

    // draw highlight overlay
    CGContextClipToMask( context, bounds, self.CGImage );
    CGContextSetBlendMode( context, kCGBlendModeOverlay );
    CGContextSetFillColorWithColor( context, color.CGColor );
    CGContextFillRect( context, bounds );

    // finish image context
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

@end

@implementation UILabel(PearlUIUtils)

- (void)autoSize {

    self.frame = CGRectSetHeight( self.frame, [self textRectForBounds:CGRectSetHeight( self.frame, CGFLOAT_MAX )
                                               limitedToNumberOfLines:self.numberOfLines].size.height );
}

@end

@implementation UIScrollView(PearlUIUtils)

- (void)autoSizeContent {

    [self autoSizeContentIgnoreHidden:YES ignoreInvisible:YES limitPadding:YES ignoreSubviewsArray:nil];
}

- (void)autoSizeContentIgnoreHidden:(BOOL)ignoreHidden
                    ignoreInvisible:(BOOL)ignoreInvisible
                       limitPadding:(BOOL)limitPadding
                     ignoreSubviews:(UIView *)ignoredSubviews, ... {

    [self autoSizeContentIgnoreHidden:ignoreHidden ignoreInvisible:ignoreInvisible limitPadding:limitPadding
                  ignoreSubviewsArray:va_array(ignoredSubviews)];
}

- (void)autoSizeContentIgnoreHidden:(BOOL)ignoreHidden
                    ignoreInvisible:(BOOL)ignoreInvisible
                       limitPadding:(BOOL)limitPadding
                ignoreSubviewsArray:(NSArray *)ignoredSubviewsArray {

    // === Step 1: Calculate the UIScrollView's contentSize.
    // Determine content frame.
    CGRect contentRect = CGRectNull;
    for (UIView *subview in self.subviews) {
        if (ignoreHidden && subview.hidden)
            continue;
        if (ignoreInvisible && !subview.alpha)
            continue;
        if ([ignoredSubviewsArray containsObject:subview])
            continue;

        CGRect subviewContent = [subview contentBoundsIgnoringSubviewsArray:ignoredSubviewsArray];
        subviewContent = [self convertRect:subviewContent fromView:subview];

        if (CGRectIsNull( contentRect ))
            contentRect = subviewContent;
        else
            contentRect = CGRectUnion( contentRect, subviewContent );
    }
    if (CGRectEqualToRect( contentRect, CGRectNull ))
            // No subviews inside the scroll area.
        contentRect = CGRectZero;

    // Add right/bottom padding by adding left/top offset to the size (but no more than 20pt if limitPadding).
    CGSize originPadding = CGSizeMake( MAX(0, contentRect.origin.x), MAX(0, contentRect.origin.y) );
    CGRect paddedRect = (CGRect){
            CGPointZero,
            CGSizeMake( contentRect.size.width + originPadding.width + (limitPadding? MIN(20, originPadding.width): originPadding.width),
                    contentRect.size.height + originPadding.height + (limitPadding? MIN(20, originPadding.height): originPadding.height) )
    };

    // Apply rect to scrollView's content definition.
    self.contentOffset = CGPointZero;
    self.contentSize = paddedRect.size;

    // === Step 2: Manage the scroll view on keyboard notifications.
    [[NSNotificationCenter defaultCenter] addObserver:[PearlUIUtils class]
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:[PearlUIUtils class]
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    if (nil == keyboardScrollViews) {
        keyboardScrollViews = [[NSMutableArray alloc] initWithCapacity:1];
    }
    bool found = false;
    for (PearlUIUtilsKeyboardScrollView *pearlKBSV in keyboardScrollViews) {
        if (pearlKBSV.keyboardScrollView == self) {
            found = true;
            break;
        }
    }
    if (!found) {

        PearlUIUtilsKeyboardScrollView *pearlKBSV = [[PearlUIUtilsKeyboardScrollView alloc] init];
        pearlKBSV.keyboardScrollView = self;
        [keyboardScrollViews addObject:pearlKBSV];
    }
}

@end

@implementation UIView(PearlUIUtils)

- (void)setFrameFromCurrentSizeAndParentPaddingTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {

    [self setFrameFromSize:self.frame.size andParentPaddingTop:top right:right bottom:bottom left:left];
}

- (void)setFrameFromSize:(CGSize)size andParentPaddingTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {

    self.frame = CGRectInCGRectWithSizeAndPadding( self.superview.bounds, size, top, right, bottom, left );
}

- (void)enumerateSubviews:(void (^)(UIView *subview, BOOL *stop, BOOL *recurse))block recurse:(BOOL)recurseDefault {

    for (UIView *subview in self.subviews) {
        BOOL stop = NO, recurse = recurseDefault;
        block( subview, &stop, &recurse );
        if (recurse)
            [subview enumerateSubviews:block recurse:recurseDefault];
        if (stop)
            break;
    }
}

- (void)printSuperHierarchy {

    NSUInteger indent = 0;
    for (UIView *view = self; view; view = view.superview) {
        dbg(PearlString( @"%%%ds - t:%%d, a:%%0.1f, h:%%@, %%@",
                indent ), "", view.tag, view.alpha, @(view.hidden), [view debugDescription]);
        indent += 4;
    }
}

- (void)printChildHierarchy {

    [self printChildHierarchyWithIndent:0];
}

- (void)printChildHierarchyWithIndent:(NSUInteger)indent {

    dbg(PearlString( @"%%%ds - t:%%d, a:%%0.1f, h:%%@, %%@", indent ), "", self.tag, self.alpha, @(self.hidden), [self debugDescription]);

    for (UIView *child in self.subviews)
        [child printChildHierarchyWithIndent:indent + 4];
}

- (UIView *)subviewClosestTo:(CGPoint)point {

    return [PearlUIUtils viewClosestTo:point ofArray:self.subviews];
}

- (CGRect)contentBoundsIgnoringSubviews:(UIView *)ignoredSubviews, ... {

    return [self contentBoundsIgnoringSubviewsArray:va_array(ignoredSubviews)];
}

- (CGRect)contentBoundsIgnoringSubviewsArray:(NSArray *)ignoredSubviewsArray {

    CGRect contentRect = self.bounds;
    if (!self.clipsToBounds)
        for (UIView *subview in self.subviews)
            if (!subview.hidden && subview.alpha && ![ignoredSubviewsArray containsObject:subview])
                contentRect = CGRectUnion( contentRect,
                        [self convertRect:
                                [subview contentBoundsIgnoringSubviewsArray:ignoredSubviewsArray]
                                 fromView:subview] );

    return contentRect;
}

- (void)showBoundingBox {

    [self showBoundingBoxOfColor:[UIColor redColor]];
}

- (void)showBoundingBoxOfColor:(UIColor *)color {

    dbg(@"Showing bounding box for view: %@", self);
    PearlBoxView *box = [PearlBoxView boxWithFrame:(CGRect){ CGPointZero, self.bounds.size } color:color];
    [self addSubview:box];
    [self addObserver:box forKeyPath:@"bounds" options:0 context:nil];
}

- (CGRect)frameInWindow {

    return [self.window convertRect:self.bounds fromView:self];
}

- (UIView *)findFirstResponderInHierarchy {

    if (self.isFirstResponder)
        return self;

    UIView *firstResponder = nil;
    for (UIView *subView in self.subviews)
        if ((firstResponder = [subView findFirstResponderInHierarchy]))
            break;

    return firstResponder;
}

- (id)clone {

    return [self cloneAddedTo:self.superview];
}

- (id)cloneAddedTo:(UIView *)superView {

    id copy = [[[self class] alloc] initWithFrame:self.frame];
    NSMutableArray *properties = [NSMutableArray array];

    // Recursively clone subviews only if this is a container-style view (ie. a UIView or UIScrollView subclass)
    BOOL recurse = YES;
    for (Class class = [self class]; class && class != [UIView class]; class = class_getSuperclass( class )) {
        if ([NSStringFromClass( [self class] ) hasPrefix:@"UI"]) {
            if ([self class] != [UIView class] && [self class] != [UIScrollView class])
                recurse = NO;
            break;
        }
    }

    // UIView
    if ([self isKindOfClass:[UIView class]]) {
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
    if ([self isKindOfClass:[UILabel class]]) {
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
    if ([self isKindOfClass:[UIControl class]]) {
        [properties addObject:@"enabled"];
        [properties addObject:@"selected"];
        [properties addObject:@"highlighted"];
        [properties addObject:@"contentVerticalAlignment"];
        [properties addObject:@"contentHorizontalAlignment"];

        // Copy actions.
        for (id target in [(UIControl *)self allTargets])
            if (target != [NSNull null])
                for (NSUInteger c = 0; c < 32; ++c)
                    for (NSString *action in [(UIControl *)self actionsForTarget:target forControlEvent:1 << c])
                        [copy addTarget:target action:NSSelectorFromString( action ) forControlEvents:1 << c];
    }

    // UITextField
    if ([self isKindOfClass:[UITextField class]]) {
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
        [copy setLeftView:[[(UITextField *)self leftView] cloneAddedTo:copy]];
        [properties addObject:@"leftViewMode"];
        [copy setRightView:[[(UITextField *)self rightView] cloneAddedTo:copy]];
        [properties addObject:@"rightViewMode"];
        [copy setInputView:[[(UITextField *)self inputView] cloneAddedTo:copy]];
        [copy setInputAccessoryView:[[(UITextField *)self inputAccessoryView] cloneAddedTo:copy]];
    }

    // UIButton
    if ([self isKindOfClass:[UIButton class]]) {
        [properties addObject:@"contentEdgeInsets"];
        [properties addObject:@"titleEdgeInsets"];
        [properties addObject:@"reversesTitleShadowWhenHighlighted"];
        [properties addObject:@"imageEdgeInsets"];
        [properties addObject:@"adjustsImageWhenHighlighted"];
        [properties addObject:@"adjustsImageWhenDisabled"];
        [properties addObject:@"showsTouchWhenHighlighted"];
        [properties addObject:@"tintColor"];
        for (NSNumber *state in [NSArray arrayWithObjects:
                PearlUnsignedInteger(UIControlStateNormal),
                PearlUnsignedInteger(UIControlStateHighlighted),
                PearlUnsignedInteger(UIControlStateDisabled),
                PearlUnsignedInteger(UIControlStateSelected),
                PearlUnsignedInteger(UIControlStateApplication),
                PearlUnsignedInteger(UIControlStateReserved),
                nil]) {
            UIControlState controlState = [state unsignedIntegerValue];

            UIButton *selfButton = (UIButton *)self;
            NSString *title = [selfButton titleForState:controlState];
            UIColor *titleColor = [selfButton titleColorForState:controlState];
            UIColor *shadowColor = [selfButton titleShadowColorForState:controlState];
            UIImage *backgroundImage = [selfButton backgroundImageForState:controlState];
            UIImage *image = [selfButton imageForState:controlState];

            if (controlState == UIControlStateNormal || title != [selfButton titleForState:UIControlStateNormal])
                [copy setTitle:title forState:controlState];
            if (controlState == UIControlStateNormal || titleColor != [selfButton titleColorForState:UIControlStateNormal])
                [copy setTitleColor:titleColor forState:controlState];
            if (controlState == UIControlStateNormal || shadowColor != [selfButton titleShadowColorForState:UIControlStateNormal])
                [copy setTitleShadowColor:shadowColor forState:controlState];
            if (controlState == UIControlStateNormal || backgroundImage != [selfButton backgroundImageForState:UIControlStateNormal])
                [copy setBackgroundImage:backgroundImage forState:controlState];
            if (controlState == UIControlStateNormal || image != [selfButton imageForState:UIControlStateNormal])
                [copy setImage:image forState:controlState];
        }
    }

    // UIImageView
    if ([self isKindOfClass:[UIImageView class]]) {
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
    [copy setValuesForKeysWithDictionary:[self dictionaryWithValuesForKeys:properties]];

    // Add copy to view's hierarchy.
    [superView addSubview:copy];

    // If requested, clone the original's subviews, too.
    if (recurse)
        for (UIView *subView in self.subviews)
            [subView cloneAddedTo:copy];

    return copy;
}

- (UIView *)localizeProperties {

    static NSArray *localizableProperties = nil;
    if (localizableProperties == nil)
        localizableProperties = [[NSArray alloc] initWithObjects:@"text", @"placeholder", nil];

    // Load localization for each of the view's supported properties.
    for (NSString *localizableProperty in localizableProperties) {
        if ([self respondsToSelector:NSSelectorFromString( localizableProperty )]) {
            id value = [self valueForKey:localizableProperty];
            if ([value isKindOfClass:[NSString class]])
                [self setValue:[PearlUIUtils applyLocalization:value] forKey:localizableProperty];
        }
    }

    // Handle certain types of view specially.
    if ([self isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentView = (UISegmentedControl *)self;

        // Localize titles of segments.
        for (NSUInteger segment = 0; segment < [segmentView numberOfSegments]; ++segment)
            [segmentView setTitle:[PearlUIUtils applyLocalization:[segmentView titleForSegmentAtIndex:segment]]
                forSegmentAtIndex:segment];
    }
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;

        // Localize titles of segments.
        UIControlState states[]
                = { UIControlStateNormal, UIControlStateHighlighted, UIControlStateDisabled, UIControlStateSelected, UIControlStateApplication };
        for (NSUInteger s = 0; s < 5; ++s) {
            UIControlState state = states[s];
            NSString *title = [button titleForState:state];
            if (title)
                [button setTitle:[PearlUIUtils applyLocalization:title] forState:state];
        }
    }
    if ([self isKindOfClass:[UITabBar class]]) {
        UITabBar *tabBar = (UITabBar *)self;

        for (UITabBarItem *item in tabBar.items)
            item.title = [PearlUIUtils applyLocalization:item.title];
    }

    // Load localization for all children, too.
    for (UIView *childView in self.subviews)
        [childView localizeProperties];

    return self;
}

@end

@implementation UIViewController(PearlUIUtils)

- (UIViewController *)localizeProperties {

    // VC properties
    self.title = [PearlUIUtils applyLocalization:self.title];
    self.navigationItem.title = [PearlUIUtils applyLocalization:self.navigationItem.title];
    [self.navigationItem.titleView localizeProperties];

    // Toolbar items
    for (UIBarButtonItem *item in [self toolbarItems]) {
        NSSet *titles = [item possibleTitles];
        NSMutableSet *localizedTitles = [NSMutableSet setWithCapacity:[titles count]];
        for (NSString *title in titles)
            [localizedTitles addObject:[PearlUIUtils applyLocalization:title]];
        [item setPossibleTitles:localizedTitles];
    }

    // VC view hierarchy
    [self.view localizeProperties];

    // Child VCs
    for (UIViewController *vc in [self childViewControllers])
        [vc localizeProperties];

    return self;
}

@end

@implementation PearlUIUtils

+ (UIView *)viewClosestTo:(CGPoint)point of:(UIView *)views, ... {

    return [self viewClosestTo:point ofArray:va_array(views)];
}

+ (UIView *)viewClosestTo:(CGPoint)point ofArray:(NSArray *)views {

    UIView *closestView = nil;
    CGFloat closestDistance = 0;
    for (UIView *view in views) {
        if (view.hidden || !view.alpha)
            continue;

        CGFloat distance = DistanceBetweenCGPointsSq( view.center, point );
        if (!closestDistance || distance < closestDistance) {
            closestDistance = distance;
            closestView = view;
        }
    }

    return closestView;
}

+ (CGRect)frameForItem:(UITabBarItem *)item inTabBar:(UITabBar *)tabBar {

    CGFloat tabItemWidth = tabBar.frame.size.width / tabBar.items.count;
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    if (tabIndex == NSNotFound)
        return CGRectNull;

    return CGRectMake( tabIndex * tabItemWidth, 0, tabItemWidth, tabBar.bounds.size.height );
}

+ (void)makeDismissable:(UIView *)views, ... {

    [self makeDismissableArray:va_array(views)];
}

+ (void)makeDismissableArray:(NSArray *)viewsArray {

    if (!dismissableResponders)
        dismissableResponders = [[NSMutableSet alloc] initWithCapacity:3];

    [dismissableResponders addObjectsFromArray:viewsArray];
}

+ (UIWindow *)findWindow {

    UIWindow *window = UIApp.keyWindow;
    if (!window)
        for (UIWindow *aWindow in UIApp.windows)
            if ([aWindow findFirstResponderInHierarchy]) {
                window = aWindow;
                break;
            }
    if (!window)
        window = [UIApp.windows objectAtIndex:0];

    return window;
}

+ (void)keyboardWillShow:(NSNotification *)n {

    UIView *responder = [[self findWindow] findFirstResponderInHierarchy];
    if (!responder)
            // Sometimes we seem to get these notifications even though there's no responder, and no keyboard shows up.
            // Don't know why but since no keyboard actually appears in this case, ignore them.
        return;

    // Find the active scrollview in our dictionary
    PearlUIUtilsKeyboardScrollView *activePearlKBSV = nil;
    if (nil != keyboardScrollViews && [keyboardScrollViews count] > 0) {

        for (PearlUIUtilsKeyboardScrollView *pearlKBSV in keyboardScrollViews) {
            if ([responder isDescendantOfView:pearlKBSV.keyboardScrollView]) {
                activePearlKBSV = pearlKBSV;
            }
        }
    }

    keyboardScrollView_shouldHide = NO;

    if (nil == activePearlKBSV) {
        // Make sure the responder is a descendant of the current view.
        return;
    }

    // Make sure no old view is still resized and a current view is set.
    if (keyboardScrollView_resized && keyboardScrollView_resized != activePearlKBSV.keyboardScrollView) {
        err(@"Keyboard shown for a scroll view while another scroll view is still resized.  We missed a keyboardWillHide: for keyboardScrollView_resized!");
        return;
    }
    assert(activePearlKBSV);
//    assert(!keyboardScrollView_resized);

    // Activate scrollview so we know which one to restore when the keyboard is hidden.
    keyboardScrollView_resized = activePearlKBSV.keyboardScrollView;

    NSDictionary *userInfo = [n userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect scrollRect = [keyboardScrollView_resized frameInWindow];
    CGRect hiddenRect = CGRectIntersection( scrollRect, keyboardRect );

    // store initial scrollview frame when needed
    if (CGRectIsNull( activePearlKBSV.keyboardScrollViewOriginalFrame )) {
        activePearlKBSV.keyboardScrollViewOriginalOffset = keyboardScrollView_resized.contentOffset;
        activePearlKBSV.keyboardScrollViewOriginalFrame = keyboardScrollView_resized.frame;
    }
    CGPoint keyboardScrollNewOffset = activePearlKBSV.keyboardScrollViewOriginalOffset;
    keyboardScrollNewOffset.y += keyboardRect.size.height / 2;
    CGRect keyboardScrollNewFrame = keyboardScrollView_resized.frame;
    keyboardScrollNewFrame.size.height -= hiddenRect.size.height;

    CGRect responderRect = [keyboardScrollView_resized convertRect:responder.bounds fromView:responder];

    if (responderRect.origin.y < keyboardScrollNewOffset.y)
        keyboardScrollNewOffset.y = 0;
    else if (responderRect.origin.y > keyboardScrollNewOffset.y + keyboardScrollNewFrame.size.height)
        keyboardScrollNewOffset.y = responderRect.origin.y;

    if (CGRectEqualToRect( keyboardScrollView_resized.frame, keyboardScrollNewFrame )) {
        // Don't change the frame if not needed.  Frame changes easily interfere with external animations.
        keyboardScrollNewFrame = CGRectNull;
    }

    if (!CGRectIsNull( keyboardScrollNewFrame )) {
        UIScrollView *animatingScrollView = keyboardScrollView_resized;
        [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0 options:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue]
                animations:^{
                    animatingScrollView.contentOffset = keyboardScrollNewOffset;
                } completion:^(BOOL finished) {
            if (!CGRectIsNull( keyboardScrollNewFrame ))
                animatingScrollView.frame = keyboardScrollNewFrame;
        }];
    }
}

+ (void)keyboardWillHide:(NSNotification *)n {

    if (!keyboardScrollView_resized)
            // Don't do any scrollview animation when no scrollview is active.
        return;

    UIScrollView *animatingScrollView = keyboardScrollView_resized;
    PearlUIUtilsKeyboardScrollView *currentPearlKBSV;
    for (PearlUIUtilsKeyboardScrollView *pearlKBSV in keyboardScrollViews) {
        if (pearlKBSV.keyboardScrollView == keyboardScrollView_resized) {
            currentPearlKBSV = pearlKBSV;
        }
    }
    if (nil == currentPearlKBSV) {
        err(@"No PearlKBSV found in dictionary yet got keyboardWillHide notification...");
        return;
    }

    CGRect animatingScrollView_originalFrame = currentPearlKBSV.keyboardScrollViewOriginalFrame;
    CGPoint animatingScrollView_originalOffset = currentPearlKBSV.keyboardScrollViewOriginalOffset;
    keyboardScrollView_shouldHide = YES;

    dispatch_async( dispatch_get_main_queue(), ^{
        if (!keyboardScrollView_shouldHide)
            return;

        currentPearlKBSV.keyboardScrollViewOriginalFrame = CGRectNull;
        currentPearlKBSV.keyboardScrollViewOriginalOffset = CGPointZero;

        CGPoint currentOffset = animatingScrollView.contentOffset;
        animatingScrollView.frame = animatingScrollView_originalFrame;
        animatingScrollView.contentOffset = currentOffset;

        [UIView animateWithDuration:[[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0 options:[[n.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue]
                animations:^{
                    animatingScrollView.contentOffset = animatingScrollView_originalOffset;
                } completion:^(BOOL finished) {
        }];

        keyboardScrollView_resized = nil;
    } );
}

+ (NSString *)applyLocalization:(NSString *)localizableValue {

    if (!localizableValue)
        return nil;

    static NSRegularExpression *UIUtils_localizableSyntax = nil;
    if (UIUtils_localizableSyntax == nil)
        UIUtils_localizableSyntax = [[NSRegularExpression alloc] initWithPattern:@"^\\{([^:]*)(?::(.*))?\\}$" options:0 error:nil];

    __block NSString *localizedValue = localizableValue;
    [UIUtils_localizableSyntax enumerateMatchesInString:localizableValue options:0 range:NSMakeRange( 0, [localizableValue length] )
                                             usingBlock:
                                                     ^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                         if (result) {
                                                             NSRange localizationKeyRange = [result rangeAtIndex:1];
                                                             NSRange defaultValueRange = [result rangeAtIndex:2];
                                                             if (NSEqualRanges( localizationKeyRange,
                                                                     NSMakeRange( NSNotFound, 0 ) ))
                                                                 return;

                                                             NSString *localizationKey
                                                                     = [localizableValue substringWithRange:localizationKeyRange];
                                                             NSString *defaultValue = nil;
                                                             if (!NSEqualRanges( defaultValueRange,
                                                                     NSMakeRange( NSNotFound, 0 ) ))
                                                                 defaultValue = [localizableValue substringWithRange:defaultValueRange];

                                                             localizedValue
                                                                     = NSLocalizedStringWithDefaultValue(localizationKey, nil, [NSBundle mainBundle], defaultValue, nil);
                                                         }
                                                     }];

    return localizedValue;
}

@end
