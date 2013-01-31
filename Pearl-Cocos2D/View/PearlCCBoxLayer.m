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
//  PearlBoxView.m
//  Pearl
//
//  Created by Maarten Billemont on 04/10/10.
//  Copyright 2010 lhunath (Maarten Billemont). All rights reserved.
//

#import "PearlCCBoxLayer.h"
#import "PearlLayout.h"
#import "PearlGLUtils.h"
#import "PearlUIUtils.h"

@implementation PearlCCBoxLayer
@synthesize color = _color;

+ (id)boxed:(CCNode *)node {

    return [self boxed:node color:ccc3to4(ccRED)];
}

+ (id)boxed:(CCNode *)node color:(ccColor4B)color {

    dbg(@"Showing bounding box for node: %@", node);
    PearlCCBoxLayer *box = [PearlCCBoxLayer boxWithSize:node.contentSize at:CGPointZero color:color];
    [node addChild:box];
    [node addObserver:box forKeyPath:@"contentSize" options:0 context:nil];

    return node;
}

+ (instancetype)boxWithSize:(CGSize)aFrame at:(CGPoint)aLocation color:(ccColor4B)aColor {

    return [[self alloc] initWithSize:aFrame at:(CGPoint)aLocation color:aColor];
}

- (id)initWithSize:(CGSize)size at:(CGPoint)aLocation color:(ccColor4B)aColor {

    if (!(self = [super init]))
        return self;

    self.position      = aLocation;
    self.contentSize   = size;
    self.color         = aColor;
    self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (object == self.parent && [keyPath isEqualToString:@"contentSize"])
        self.contentSize = self.parent.contentSize;
}

- (void)draw {

    [super draw];

    CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"PearlCCBoxLayer - draw");
    CC_NODE_DRAW_SETUP();

    ccColor4B backColor = self.color;
    backColor.a = 0x33;

    PearlGLDrawBoxFrom(CGPointZero, CGPointFromCGSize(self.contentSize), backColor);
    PearlGLDrawBorderFrom(CGPointZero, CGPointFromCGSize(self.contentSize), self.color);

    CHECK_GL_ERROR_DEBUG();
    CC_INCREMENT_GL_DRAWS(1);
    CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"PearlCCBoxLayer - draw");
}

@end
