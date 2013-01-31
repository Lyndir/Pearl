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
//  PearlCCDebugLayer.m
//  Pearl
//
//  Created by Maarten Billemont on 06/07/09.
//  Copyright 2009 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCDebugLayer.h"
#import "PearlGLUtils.h"

@implementation PearlCCDebugLayer


+ (instancetype)get {

    static PearlCCDebugLayer *instance = nil;
    if (!instance)
        instance = [self new];

    return instance;
}

- (id)init {

    if (!(self = [super init]))
        return nil;

    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];

    return self;
}


- (void)draw {

    [super draw];

    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"PearlCCDebugLayer - draw");
    CC_NODE_DRAW_SETUP();

    PearlGLDrawIndicators();

    CHECK_GL_ERROR_DEBUG();
    CC_INCREMENT_GL_DRAWS(1);
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"PearlCCDebugLayer - draw");
}

@end
