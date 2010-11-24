//
//  BoxView.h
//  iLibs
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
}

@property (nonatomic, retain) UIColor   *color;

+ (BoxView *)boxWithFrame:(CGRect)aFrame color:(UIColor *)aColor;

- (id)initWithFrame:(CGRect)aFrame color:(UIColor *)aColor;

@end
