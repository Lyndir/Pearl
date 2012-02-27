/*
 *   Copyright 2009, Maarten Billemont
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

//
//  PearlMessageView.h
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * A message view is a plain view that renders a backdrop suitable for displaying a message in.
 */
@interface PearlMessageView : UIView {

    BOOL                                    _initialized;
    UIRectCorner                            _corners;
    UIColor                                 *_fill;
    CGSize                                  _radii;
}

@property (nonatomic, assign) UIRectCorner  corners;
@property (nonatomic, retain) UIColor       *fill;
@property (nonatomic, assign) CGSize        radii;

@end
