//
// Created by Maarten Billemont on 2017-12-11.
// Copyright (c) 2017 Tristan Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Views for easy overriding and break-pointing regular objects for purposes of debugging. */

@interface WTFView : UIView
@end

@interface WTFLabel : UILabel
@end

@interface WTFAutoresizingContainerView : AutoresizingContainerView
@end

NS_CLASS_AVAILABLE_IOS(9_0)
@interface WTFStackView : UIStackView
@end

