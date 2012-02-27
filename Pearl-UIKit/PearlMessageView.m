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
//  PearlBoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlMessageView.h"
#import "PearlLayout.h"
#import "PearlUIUtils.h"
#import <QuartzCore/QuartzCore.h>


@implementation PearlMessageView
@synthesize corners = _corners, fill = _fill, radii = _radii;

- (id)initWithFrame:(CGRect)aFrame {
    
    if (!(self = [super initWithFrame:aFrame]))
        return self;
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (!_initialized) {
        self.layer.masksToBounds = NO;
        //self.layer.shadowColor = [UIColor whiteColor].CGColor;
        //self.layer.shadowOffset = CGSizeMake(0, 2);
        //self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5f;

        self.corners    = UIRectCornerAllCorners;
        self.fill       = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.radii      = CGSizeMake(10, 10);
        
        _initialized = YES;
    }
    
    [self.fill setFill];
    [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.corners cornerRadii:self.radii] fill];
}

@end
