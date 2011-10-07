//
//  BoxView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A box view is a plain view that renders a bounding box.
 */
@interface BoxView : UIView {

    UIColor                             *_color;
    CGFloat                             _width;
    BOOL                                _filled;
}

@property (nonatomic, retain) UIColor   *color;
@property (nonatomic, assign) CGFloat   width;
@property (nonatomic, assign) BOOL      filled;

+ (id)boxed:(id)view;
+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor;
+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor width:(CGFloat)width;

@end
