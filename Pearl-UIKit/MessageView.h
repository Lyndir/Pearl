//
//  MessageView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A message view is a plain view that renders a backdrop suitable for displaying a message in.
 */
@interface MessageView : UIView {

    BOOL                                    _initialized;
    UIRectCorner                            _corners;
    UIColor                                 *_fill;
    CGSize                                  _radii;
}

@property (nonatomic, assign) UIRectCorner  corners;
@property (nonatomic, retain) UIColor       *fill;
@property (nonatomic, assign) CGSize        radii;

@end
