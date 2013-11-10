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
//  PearlCCMenuItemBlock.m
//  Pearl
//
//  Created by Maarten Billemont on 08/06/11.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCMenuItemBlock.h"
#import "PearlUIUtils.h"

@implementation PearlCCMenuItemBlock


+ (instancetype)itemWithSize:(NSUInteger)size {

    return [[self alloc] initWithSize:size target:self selector:@selector(nothing:)];
}


+ (instancetype)itemWithSize:(NSUInteger)size target:(id)target selector:(SEL)selector {

    return [[self alloc] initWithSize:size target:target selector:selector];
}

- (id)initWithSize:(NSUInteger)size target:(id)target selector:(SEL)selector {

    if (!(self = [super initWithTarget:target selector:selector]))
        return nil;

    self.contentSize   = CGSizeMake(size, size);
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];

    return self;
}

- (void)draw {

    [super draw];

    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"PearlCCMenuItemBlock - draw");
    CC_NODE_DRAW_SETUP();

    if (!self.isEnabled) {
        ccDrawColor4B(0xff, 0xff, 0xff, 0xff);
        glLineWidth( 5 );
        ccDrawLine(CGPointZero, CGPointFromCGSize(self.contentSize));
        glLineWidth( 1 );
    }

    CHECK_GL_ERROR_DEBUG();
    CC_INCREMENT_GL_DRAWS(1);
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"PearlCCMenuItemBlock - draw");
}

+ (void)nothing:(id)sender {
}

@end
